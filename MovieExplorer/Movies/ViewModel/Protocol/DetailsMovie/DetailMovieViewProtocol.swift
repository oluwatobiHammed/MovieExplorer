//
//  DetailMovieViewProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

protocol DetailMovieViewProtocol: AnyObject {
    func updateLikeButton(isfavorite: Bool)
    func showAlert(title: String?, message: String)
}
