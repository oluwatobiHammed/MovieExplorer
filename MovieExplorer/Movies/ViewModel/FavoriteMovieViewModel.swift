//
//  FavoriteMovieViewModel.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

class FavoriteMovieViewModel {
    
    weak var view : FavoriteListViewProtocol?
    private var networkManager: ManagerProtocol
    private var movieResult: [Movie] = []
    private var movieList: FavoriteMovies?
    private var currentPage = 1
    
    init(setView view: FavoriteListViewProtocol?, networkManager: ManagerProtocol) {
        if let view  { self.view = view }
        self.networkManager = networkManager
    }
}

extension FavoriteMovieViewModel: FavoriteMovieViewModelProtocol {
    func getFavorite(page: Int) {
        networkManager.getFavorite(page: page) { [self] movies, error in
            if error == nil {
                DispatchQueue.main.sync {
                    guard let movies, movies.results.count > 0  else {
                        movieList = nil
                        movieResult.removeAll()
                        view?.reloadMovieTableView()
                        return }
                    if page < 2 {
                        movieList = nil
                        movieResult.removeAll()
                    }
                    if self.movieList?.results.count ?? 0 < 1 {
                        self.movieList = movies
                        self.movieResult = Array(movies.results)
                    } else {
                        self.movieList = movies
                        self.movieResult.append(contentsOf: movies.results)
                    }
                    view?.reloadMovieTableView()
                }
                
            } else {
                DispatchQueue.main.sync {
                    getMovies()
                }
                guard let error, movieResult.count > 0 else {return}
                self.view?.showAlert(title: "No Movies Found", message: error.localizedDescription)
            }
        }
    }
    
    func getMovies() {
        if let movies = MovieRealmManager.shared.favoriteMovies {
            movieResult = Array(movies.results)
            movieList = movies
            view?.reloadMovieTableView()
        }
    }
    
    func pagination(index: Int) {
        if  currentPage  < movieList?.totalPages ?? 0, index == movieResult.count - 1 {
            currentPage += 1
            getFavorite(page: currentPage)
        }
     
    }
    
    func numberofMovies() -> (Int, [Movie]) {
        (movieList?.totalPages ?? 0,movieResult)
    }
    

    
}

