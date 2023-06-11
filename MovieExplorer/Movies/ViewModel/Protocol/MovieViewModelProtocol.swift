//
//  MovieViewModelProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//

import Foundation

protocol MovieViewModelProtocol {
    func handleSendButton(query: String)
    func numberofMovies() -> (Int, [Movie])
    func getMovies()
    func pagination(index: Int)
}

