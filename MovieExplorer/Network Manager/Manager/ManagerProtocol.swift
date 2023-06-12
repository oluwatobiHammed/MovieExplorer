//
//  ManagerProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation

protocol ManagerProtocol {
    func getSearch(page: Int, query: String, completion: @escaping (_ movies: Movies?, _ error: Error?)->())
    func addFavorite(movieId: Int, isfavorite: Bool, completion: @escaping (_ error: Error?)->())
    func getFavorite(page: Int, completion: @escaping (_ movies: FavoriteMovies?, _ error: Error?)->())
}
