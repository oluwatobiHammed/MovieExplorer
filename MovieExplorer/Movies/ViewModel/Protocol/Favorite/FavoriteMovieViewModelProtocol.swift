//
//  FavoriteMovieViewModelProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation


protocol FavoriteMovieViewModelProtocol {
    func pagination(index: Int)
    func numberofMovies() -> (Int, [Movie])
    func getFavorite(page: Int)
}
