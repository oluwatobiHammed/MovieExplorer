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
    private var listOfLiked =  UserManager().readSkippedContent()
    
    init(setView view: FavoriteListViewProtocol?, networkManager: ManagerProtocol) {
        if let view  { self.view = view }
        self.networkManager = networkManager
    }
}

extension FavoriteMovieViewModel: FavoriteMovieViewModelProtocol {
    
    
    func getFavorite(page: Int) {
        
        networkManager.getFavorite(page: page) { [self] result in
            DispatchQueue.main.sync {
                switch result {
                case .failure(let err):
                    
                    getMovies()
                    view?.reloadMovieTableView()
                    guard movieResult.count > 0 else {return}
                    view?.showAlert(title: "No Movies Found", message: err.localizedDescription)
                    
                case .success(let movies):
                    
                    guard movies.results.count > 0  else {
                        movieList = nil
                        movieResult.removeAll()
                        if listOfLiked.isEmpty {
                            MovieRealmManager.shared.clearFavoriteMovies()
                        }
                        
                        view?.reloadMovieTableView()
                        return }
                    if page < 2 {
                        movieList = nil
                        movieResult.removeAll()
                    }
                    if self.movieList?.results.count ?? 0 < 1 {
                       movieList = movies
                       movieResult = Array(movies.results)
                    } else {
                        movieList = movies
                        movieResult.append(contentsOf: movies.results)
                    }
                    view?.reloadMovieTableView()
                }
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
    
    private func addNotificationObserver() {
        // Favorite Movie update
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddedFavoriteMovie), name: NSNotification.Name(rawValue: "updateAddedFavoriteMovie"), object: nil)
    }
    
    @objc func updateAddedFavoriteMovie() {
        getFavorite(page: 1)
    }
    
    func viewDidLoad() {
        addNotificationObserver()
    }
    
}

