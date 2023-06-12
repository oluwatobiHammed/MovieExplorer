//
//  MoviesEndpoints.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation

enum MovieEndpoints: EndPointType {
    case search(query: String, page: Int)
    case addFavorite(movie: Int, isfavorite: Bool)
    case getFavorite(page: Int)
    
    var baseURL: URL {
        guard let url = URL(string: kAPI.Base_URL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .search:
            return kAPI.Endpoints.search
        case .addFavorite:
            return kAPI.Endpoints.favorite
        case .getFavorite:
            return kAPI.Endpoints.favoriteList
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .addFavorite:
            return .post
        default:
            return .get
        }
        
    }
    
    var task: HTTPTask {
        switch self {
            
            case .search(let query, let page):
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    bodyEncoding: .urlEncoding,
                                                    urlParameters: ["page" : page, "query": query, "include_adult": false],
                                                    additionHeaders: headers)
            
        case .addFavorite(let mediaId, let isfavorite):
            
            var bodyParameters : [String : Any] = ["media_type" : "movie","favorite": isfavorite]
        
            bodyParameters["media_id"] = mediaId
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                bodyEncoding: .urlAndJsonEncoding,
                                                urlParameters: nil,
                                                additionHeaders: headers)
        case .getFavorite(let page):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["page" : page, "sort_by": "created_at.desc"],
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



extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
