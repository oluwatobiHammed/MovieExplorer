//
//  DetailMovieViewModel.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import Foundation

class DetailMovieViewModel {
    
    
    weak var view : DetailMovieViewProtocol?
    private var networkManager: ManagerProtocol
    private var listOfLiked =  UserManager().readSkippedContent()
    
    init(setView view: DetailMovieViewProtocol?, networkManager: ManagerProtocol) {
        if let view  { self.view = view }
        self.networkManager = networkManager
    }
}

extension DetailMovieViewModel: DetailMovieViewModelProtocol {
    func addFavoiteMovie(movieId: Int, isfavorite: Bool) {
        networkManager.addFavorite(movieId: movieId, isfavorite: isfavorite) { [self] result in
            
            DispatchQueue.main.async { [self] in
                switch result {
                case .success:
                    view?.updateLikeButton(isfavorite: isfavorite)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAddedFavoriteMovie") , object: nil)
                    if isfavorite {
                        listOfLiked.append(movieId)
                        UserManager().setSkippedContent(listOfLiked)
                    } else {
                        guard let removeIndex = listOfLiked.firstIndex(where: {$0 == movieId}) else { return }
                        listOfLiked.remove(at: removeIndex)
                        UserManager().setSkippedContent(listOfLiked)
                    }
                case .failure(let error):
                    view?.showAlert(title: "Something happened", message: error.localizedDescription)
                }
            }
        }
    }
    
}


