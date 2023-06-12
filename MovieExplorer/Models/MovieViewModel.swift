//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

struct MovieViewModel {
    
    var backdropPath     : String,
        originalLanguage : String,
        originalTitle    : String,
        overview         : String,
        posterPath       : String,
        releaseDate      : String,
        title            : String
    var popularity       : Double,
        voteAverage      : Double
    var id               : Int,
        voteCount        : Int
    var video            : Bool
    
    
    init(movie: Movie) {
        self.backdropPath = movie.backdropPath!
        self.originalLanguage = movie.originalLanguage!
        self.originalTitle = movie.originalTitle!
        self.overview = movie.overview!
        self.posterPath = movie.posterPath!
        self.releaseDate = movie.releaseDate!
        self.title = movie.title!
        self.popularity =  movie.popularity
        self.voteCount = movie.voteCount
        self.id = movie.id
        self.video = movie.video
        self.voteAverage = movie.voteAverage
    }
    
}


struct MoviesViewModel {
    var results       : [Movie]
    var totalPages    : Int
    var page          : Int
    
    init(movie: Movies) {
        self.page = movie.page
        self.totalPages = movie.totalPages
        self.results = Array(movie.results)
    }
}
