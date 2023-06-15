//
//  FavouriteMoviesViewController.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import UIKit
import SnapKit

class FavoriteMoviesViewController: BaseViewController {
    
    
    // MARK: Properties
    private var networkManager = NetworkManager()

    
    private lazy var favouriteMovieViewViewModel: FavoriteMovieViewModelProtocol = {
        return FavoriteMovieViewModel(setView: self, networkManager: networkManager)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        favouriteMovieViewViewModel.viewDidLoad()
        favouriteMovieViewViewModel.getFavorite(page: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
        errorTitle.isHidden = (movieResult.count > 0)
    }
    
    
    lazy var refreshControl : UIRefreshControl = {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handlePullDownToRefresh), for: UIControl.Event.valueChanged)
        return $0
    }(UIRefreshControl(frame: .zero))

    
    @objc private func handlePullDownToRefresh() {
        favouriteMovieViewViewModel.getFavorite(page: 1)
    }
    
    override func numberofMovies(total: Int = 0, movie: [Movie] = []) -> (Int, [Movie]) {
        return favouriteMovieViewViewModel.numberofMovies()
    }
    
    override func pagination(index: Int) {
        favouriteMovieViewViewModel.pagination(index: index)
    }
    

}



extension FavoriteMoviesViewController: FavoriteListViewProtocol {
    
    func showAlert(title: String?, message: String) {
        AlertManager.sharedAlertManager.showAlertWithTitle(title: title ?? "", message: message, controller: self)
    }
    
    func reloadMovieTableView() {
        movieListTableView.reloadData()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
        errorTitle.isHidden = (movieResult.count > 0)
    }


}
