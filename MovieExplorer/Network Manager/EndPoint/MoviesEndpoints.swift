//
//  MoviesEndpoints.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation

enum MovieEndpoints: EndPointType {
    case getMovies(page: Int)
    case getNowPlayinMovies(page: Int)
    case search(query: String, page: Int)
    
    var baseURL: URL {
        guard let url = URL(string: kAPI.Base_URL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return kAPI.Endpoints.discover
        case .getNowPlayinMovies:
            return kAPI.Endpoints.nowPlaying
        case .search:
            return kAPI.Endpoints.search
        }
    }
    
    var httpMethod: HTTPMethod {
        return.get
    }
    
    var task: HTTPTask {
        switch self {
        case .getMovies(let page):
            let trimmedDictionary = getTrimmedDict(page: page)
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: trimmedDictionary as Parameters,
                                                additionHeaders: headers)
            
            case .getNowPlayinMovies(let page):
                let trimmedDictionary = getTrimmedDict(page: page)
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    bodyEncoding: .urlEncoding,
                                                    urlParameters: ["page" : page],
                                                    additionHeaders: headers)
            
            
            case .search(let query, let page):
                let trimmedDictionary = getTrimmedDict(page: page)
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    bodyEncoding: .urlEncoding,
                                                    urlParameters: ["page" : page, "query": query, "include_adult": false],
                                                    additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            
            return ["Authorization": "Bearer " + "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkY2M4ZTE2NmM5MDc2NDFmOTJmMzkwMWNhYzcyMWVjMyIsInN1YiI6IjVkMTRlN2M0YWY1OGNiMDAzMGI3NWEzZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9cvS66f8etlTvhzlotPNkZnAR0c_M-dNFgIuWgljyog"]
            
            
        }
    }
    
    
}


extension MovieEndpoints {
    
    func getTrimmedDict(page: Int) -> [String: Any?] {
        let preparedDictionary: [String: Any?] =  [
            "include_adult": false,
            "include_video": false,
            "page": page,
            "sort_by": "popularity.desc",
        ]
        
        var trimmedDictionaryForNilValues = preparedDictionary.filter ({ $0.value != nil }).mapValues( { $0 })
        
        let keysToRemove = trimmedDictionaryForNilValues
        
        for key in keysToRemove {
            if let value = key.value as? String{
                if value == "" {
                    trimmedDictionaryForNilValues.removeValue(forKey: key.key)
                }
            }
        }
        return trimmedDictionaryForNilValues
    }
    
    
    
    
    
}


extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
