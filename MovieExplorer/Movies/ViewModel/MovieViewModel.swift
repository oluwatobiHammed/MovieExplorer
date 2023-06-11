//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//



import Foundation

class MovieViewModel {
    
    
    weak var view : MovieListViewProtocol?
    private let networkManager = NetworkManager()
    private var movieResult: [Movie] = []
    private var movieList: Movies?
    private var sendButtonPressed: Bool = false
    private var currentPage = 1
    
    
    init(setView view: MovieListViewProtocol?) {
        if let view  { self.view = view }
        
    }
}

extension MovieViewModel: MovieViewModelProtocol {
    func pagination(index: Int) {
        if  currentPage  < movieList?.totalPages ?? 0, index == movieResult.count - 1 {
            currentPage += 1
            getQueryText(page: currentPage)
        }
    }
    
    
    
    func numberofMovies() -> (Int, [Movie]) {
        (movieList?.totalPages ?? 0,movieResult)
    }
    func getMovies() {
        if let movies = MovieRealmManager.shared.movies {
            movieResult = Array(movies.results)
            movieList = movies
        }
    }

    func handleSendButton(query: String) {
        if currentPage > 1 {
            currentPage = 1
        }
        UserDefaults.standard.removeObject(forKey: "searchQuery")
        MovieRealmManager.shared.deleteDatabase()
        movieList = nil
        movieResult.removeAll()
        UserDefaults.standard.set(query, forKey: "searchQuery")
        sendButtonPressed = true
        getQueryText(page: currentPage)
    }
    
    private func getQueryText(page: Int) {
        guard let query = UserDefaults.standard.string(forKey: "searchQuery")  else { view?.showAlert(title: nil, message: "Type in a movie name to search for a movie")
            return }
        networkManager.getSearch(page: page, query: query) { [weak self] movie, err in
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                if err == nil {
                    guard let movie, movie.results.count > 0  else {
                        self.view?.showAlert(title: "No Movies Found", message: "Try adjusting your query and try again")
                        return}
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
