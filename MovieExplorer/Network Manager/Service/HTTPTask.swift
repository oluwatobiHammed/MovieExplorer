//
//  HTTPTask.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation
import UIKit

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    case requestArrayParametersAndHeaders(bodyParameters: ArrayParameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    case requestHeaders(bodyEncoding: ParameterEncoding, additionHeaders: HTTPHeaders?)
    
    case requestParametersAndHeadersWithImage(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        imageTuple: (UIImage?, String)?,
        additionHeaders: HTTPHeaders?)
}
