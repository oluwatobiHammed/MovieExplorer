//
//  MovieListControllerProtocol.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation

protocol SearchMovieListViewProtocol: AnyObject {
    func reloadMovieTableView(sendButtonPressed: Bool)
    func showAlert(title: String?, message: String)
}
