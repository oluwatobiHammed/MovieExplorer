//
//  FavoriteListViewProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

protocol FavoriteListViewProtocol: AnyObject {
    func reloadMovieTableView()
    func showAlert(title: String?, message: String)
}
