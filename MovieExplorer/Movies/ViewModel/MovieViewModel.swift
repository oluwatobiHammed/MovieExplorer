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
    
    func getQueryText(page: Int) {
        guard let query = UserDefaults.standard.string(forKey: "searchQuery")  else { view?.showAlert(title: nil, message: "Type in a movie name to search for a movie")
            return }
        networkManager.getSearch(page: page, query: query) { [weak self] movie, err in
            
            DispatchQueue.main.async { [weak self] in
                guard let self, let movie else {return}
                if err == nil {
                    if movieList?.results.count ?? 0 < 1 {
                        movieList = movie
                        movieResult = Array(movie.results)
                    } else {
                        movieList = movie
                        movieResult.append(contentsOf: movie.results)
                    }
                } else {
                    view?.showAlert(title: "Something went wrong", message: "We are experiencing technical difficulties. Please try again later.")
                }
           
                view?.reloadMovieTableView(sendButtonPressed: sendButtonPressed)
                sendButtonPressed = false
         
            }
            
        }
    }
}
