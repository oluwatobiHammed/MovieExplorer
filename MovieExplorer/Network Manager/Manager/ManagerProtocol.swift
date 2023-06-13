//
//  ManagerProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation

protocol ManagerProtocol {
    func getSearch(page: Int, query: String, completion: @escaping (ApiResults<Movies>) -> Void )
    func addFavorite(movieId: Int, isfavorite: Bool, completion: @escaping (Result<Error>)-> Void)
    func getFavorite(page: Int, completion: @escaping (ApiResults<FavoriteMovies>) -> Void)
}
