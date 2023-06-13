//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//



import Foundation

class SearchedMovieViewModel {
    
    
    weak var view : SearchMovieListViewProtocol?
    private var networkManager: ManagerProtocol
    private var movieResult: [Movie] = []
    private var movieList: Movies?
    private var sendButtonPressed: Bool = false
    private var currentPage = 1
    
    
    init(setView view: SearchMovieListViewProtocol?, networkManager: ManagerProtocol) {
        if let view  { self.view = view }
        self.networkManager = networkManager
    }
}

extension SearchedMovieViewModel: SearchedMovieViewModelProtocol {
    
    func pagination(index: Int) {
        guard let query = UserDefaults.standard.string(forKey: "searchQuery") else {return}
        
        if  currentPage  < movieList?.totalPages ?? 0, index == movieResult.count - 1 {
            currentPage += 1
            getQueryText(page: currentPage, query: query)
        }
    }
    
    
    
    func numberofMovies() -> (Int, [Movie]) {
        (movieList?.totalPages ?? 0,movieResult)
    }
    
    func getMovies() {
        if let movies = MovieRealmManager.shared.movies {
            movieResult = Array(movies.results)
            movieList = movies
            view?.reloadMovieTableView(sendButtonPressed: sendButtonPressed)
        }
    }

    func handleSendButton(query: String) {
        if currentPage > 1 {
            currentPage = 1
        }
        
        sendButtonPressed = true
        getQueryText(page: currentPage, query: query)
    }
    
    private func getQueryText(page: Int, query: String?) {
        if UserDefaults.standard.string(forKey: "searchQuery") != query {
            MovieRealmManager.shared.clearSearchMovies()
        }
        guard let query else {
            view?.showAlert(title: nil, message: "Type in a movie name to search for a movie")
            return }
        networkManager.getSearch(page: page, query: query) { movie, err in
            
            DispatchQueue.main.async { [self] in
                
                if err == nil {
                    guard let movie, movie.results.count > 0  else {
                        self.view?.showAlert(title: "No Movies Found", message: "Check your search spelling and try again")
                        return }
                    if page == 1 {
                        movieList = nil
                        movieResult.removeAll()
                        UserDefaults.standard.removeObject(forKey: "searchQuery")
                        UserDefaults.standard.set(query, forKey: "searchQuery")
                    }
                    if self.movieList?.results.count ?? 0 < 1 {
                        self.movieList = movie
                        self.movieResult = Array(movie.results)
                    } else {
                        self.movieList = movie
                        self.movieResult.append(contentsOf: movie.results)
                    }
                    
                    self.view?.reloadMovieTableView(sendButtonPressed: sendButtonPressed)
                    self.sendButtonPressed = false
                } else {
                    guard let err else {return}
                    self.view?.showAlert(title: "Something went wrong", message: err.localizedDescription)
                }
                
            }
            
        }
    }
}
