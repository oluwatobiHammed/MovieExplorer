//
//  kAPI.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation


struct kAPI {
    static let Base_URL = "https://api.themoviedb.org/3"
    static let Base_img_URL = "https://image.tmdb.org/t/p/w300"
    
    
    struct Endpoints {
        static let discover           = "/discover/movie"
        static let nowPlaying         = "/movie/now_playing"
        static let search             = "/search/movie"
        static let favorite           = "/account/8527385/favorite"
    }
}
