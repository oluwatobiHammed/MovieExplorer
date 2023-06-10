//
//  MovieViewModelProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//

import Foundation

protocol MovieViewModelProtocol {
    func getQueryText(page: Int)
    func handleSendButton(query: String, currentPage: Int)
    func numberofMovies() -> (Int, [Movie])
    func getMovies()
}

