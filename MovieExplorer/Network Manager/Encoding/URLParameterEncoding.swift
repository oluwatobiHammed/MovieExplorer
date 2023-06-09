//
//  URLParameterEncoding.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation
import UIKit

public struct URLParameterEncoder: ParameterEncoder {
    
    public func encode(urlRequest: inout URLRequest, withParameters parameters: Parameters? = nil, withImageTuple imageTuple: (UIImage?, String)?) throws {
        
    }
    
    public func encode(urlRequest: inout URLRequest, withArrayParameters arrayParameters: ArrayParameters) throws {
        
    }
    
    public func encode(urlRequest: inout URLRequest, withParameters parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
}
