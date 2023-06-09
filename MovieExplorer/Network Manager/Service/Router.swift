//
//  Router.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation
import UIKit

enum NetworkResponse:String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case unableToConvertToImage = "We could not convert response data to image."
}

enum NetworkEnvironment {
    case RELEASE, PRODUCTION, DEVELOPMENT
}


enum Result<Error>{
    case success
    case failure(Error)
}

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) async
    func cancel()
}
struct ErrorMessages: Decodable, Error {
    let message: [String]?
    let email: [String]?
}
class Router<EndPoint: EndPointType>: NetworkRouter {

    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) async {
        
        do {
            
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {return}
            completion(data, response,handleNetworkResponse(response))
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    
    func requestURL(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        task = session.dataTask(with: route.baseURL, completionHandler: { (data, response, error) in
            completion(data, response, error)
        })
        self.task?.resume()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Error?{
        switch response.statusCode {
        case 200...299: break
        case 404: break
        case 401...500: return  NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.authenticationError.rawValue])
        case 501...599: return  NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.badRequest.rawValue])
        case 600: return  NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.outdated.rawValue])
        default: return   NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.failed.rawValue])
        }
        return nil
    }

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 12.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestArrayParametersAndHeaders(let bodyArrayParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureArrayParameters(bodyArrayParameters: bodyArrayParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
                
            case .requestParametersAndHeadersWithImage(let bodyParameters, let bodyEncoding, let urlParameters, let imageTuple, let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                guard let (image, fieldKey) = imageTuple else { return request }
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             imageTuple: (image, fieldKey),
                                             request: &request)
                
            case .requestHeaders(let bodyEncoding, let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: nil,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: nil,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         imageTuple: (UIImage?, String)? = nil,
                                         request: inout URLRequest) throws {
        do {
            
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters, imageTuple: imageTuple)
        } catch {
            throw error
        }
    }
    
    
    fileprivate func configureArrayParameters(bodyArrayParameters: ArrayParameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         imageTuple: (UIImage?, String)? = nil,
                                         request: inout URLRequest) throws {
        do {
            
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: nil, bodyArrayParameters: bodyArrayParameters, urlParameters: urlParameters, imageTuple: imageTuple)
        } catch {
            throw error
        }
    }
    
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}


