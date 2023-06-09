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
        let oldQuery = UserDefaults.standard.string(forKey: "searchQuery")

        guard let query else {
            view?.showAlert(title: nil, message: "Type in a movie name to search for a movie")
            return }
        networkManager.getSearch(page: page, query: query) { result in
            
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let movies):
                    guard movies.results.count > 0  else {
                        self.view?.showAlert(title: "No Movies Found", message: "Check your search spelling and try again")
                        return }
                    if page == 1 {
                        movieList = nil
                        movieResult.removeAll()
                        if oldQuery != query && MovieRealmManager.shared.movies != nil {
                             MovieRealmManager.shared.clearSearchMovies()
                        }
                        UserDefaults.standard.removeObject(forKey: "searchQuery")
                        UserDefaults.standard.set(query, forKey: "searchQuery")
                    }
                    if self.movieList?.results.count ?? 0 < 1 {
                        self.movieList = movies
                        self.movieResult = Array(movies.results)
                    } else {
                        self.movieList = movies
                        self.movieResult.append(contentsOf: movies.results)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                        MovieRealmManager.shared.updateOrSave(realmObject: movies)
                    })
                    self.view?.reloadMovieTableView(sendButtonPressed: sendButtonPressed)
                    self.sendButtonPressed = false
                case .failure(let err):
                    self.view?.showAlert(title: "Something went wrong", message: err.localizedDescription)
                }
                
            }
            
        }
    }
    
    
    private func addNotificationObserver() {
        // Favorite Movie update
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddedFavoriteMovie), name: NSNotification.Name(rawValue: "updateAddedFavoriteMovie"), object: nil)
    }
    
    @objc func updateAddedFavoriteMovie() {
        view?.reloadMovieTableView(sendButtonPressed: false)
    }
    
    func viewDidLoad() {
        addNotificationObserver()
    }
}
