//
//  ParameterEncoding.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation
import UIKit

public typealias Parameters = [String : Any]
public typealias ArrayParameters = T
public typealias T = Encodable

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, withParameters parameters: Parameters) throws
    func encode(urlRequest: inout URLRequest, withArrayParameters arrayParameters: ArrayParameters) throws
    func encode(urlRequest: inout URLRequest, withParameters parameters: Parameters?, withImageTuple tupleImage: (UIImage?, String)?) throws
    
}


public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    case urlAndArrayJsonEncoding
    case urlAndJsonImageEncoding
    case bodyAndHeaderEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       bodyArrayParameters: ArrayParameters? = nil,
                       urlParameters: Parameters?,
                       imageTuple: (UIImage?, String)? = nil) throws {
        do {
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if urlRequest.value(forHTTPHeaderField: "accept") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            }
            
            
            let clarifiedBodyParameters: Parameters? = (bodyParameters?.count ?? 0) > 0 ? bodyParameters : nil
            
            let clarifiedBodyArrayParameters: ArrayParameters? = bodyArrayParameters

            
            var params = urlParameters ?? [String: Any]()
            params.updateValue("dcc8e166c907641f92f3901cac721ec3", forKey: "api_key")
            params.updateValue("en-US", forKey: "language")

            
            
            switch self {
            case .urlEncoding:
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                
            case .jsonEncoding:
                
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                
                if let bodyParameters = clarifiedBodyParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, withParameters: bodyParameters)
                }
                
                
            case .urlAndJsonEncoding:
                
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                
                if let bodyParameters = clarifiedBodyParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, withParameters: bodyParameters)
                }
                
                
            case .urlAndArrayJsonEncoding:
                
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                
                if let bodyArrayParameters = clarifiedBodyArrayParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, withArrayParameters: bodyArrayParameters)
                }
                
                
            case .urlAndJsonImageEncoding:
                
                guard let imageTuple = imageTuple else { return }
                
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, withParameters: bodyParameters, withImageTuple: imageTuple)
                
            case .bodyAndHeaderEncoding:
                
                try URLParameterEncoder().encode(urlRequest: &urlRequest, withParameters: params)
                
                if let bodyParameters = clarifiedBodyParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, withParameters: bodyParameters)
                }
                
                
            }
        } catch {
            throw error
        }
    }
}




public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

