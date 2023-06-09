//
//  kAPI.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation


struct kAPI {
    static let Base_URL = "https://api.themoviedb.org/3"
    
    
    struct Endpoints {
        static let discover           = "/discover/movie"
        static let nowPlaying         = "/movie/now_playing"
        static let search             = "/search/movie"
    }
}
