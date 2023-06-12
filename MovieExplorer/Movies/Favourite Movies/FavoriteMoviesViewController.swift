//
//  FavouriteMoviesViewController.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import UIKit
import SnapKit

class FavoriteMoviesViewController: UIViewController {
    
    
    // MARK: Properties
    private let movieUnavailableCellIdentifier = "UnavailableCellIdentifier"
    private var networkManager = NetworkManager()
    
    private var tabBarHeight: CGFloat {
        return  10 + (tabBarController?.tabBar.frame.size.height ?? 0)
    }
    
    private let naVBarView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    
    private lazy var movieListTableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: MovieDetailTableViewCell.reuseIdentifier)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: movieUnavailableCellIdentifier)
        $0.separatorStyle = .none
        $0.backgroundColor = kColor.BrandColours.Bizarre
        $0.contentInsetAdjustmentBehavior = .never
        $0.keyboardDismissMode = .interactive
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: tabBarHeight, right: 0)
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        $0.alwaysBounceVertical = true
        $0.refreshControl = refreshControl
        return $0
    }(UITableView())
    
    private var errorTitle: UILabel = {
        let label = UILabel()
        label.text = "Add favorite movies here"
        label.textColor = kColor.BrandColours.DarkGray
        label.textAlignment = .center
        label.font = kFont.EffraRegular.of(size: 16)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var favouriteMovieViewViewModel: FavoriteMovieViewModelProtocol = {
        return FavoriteMovieViewModel(setView: self, networkManager: networkManager)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        favouriteMovieViewViewModel.getFavorite(page: 1)
        setUpview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouriteMovieViewViewModel.getFavorite(page: 1)
        let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
        errorTitle.isHidden = (movieResult.count > 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: setUpview
    private func setUpview() {
        let icon = UIImage(named: .darktmdb)
        let centerImageTitleView  = centerImageTitleView(icon: icon, subTitle: "Millions of movies TV shows and people to discover")
        view.addSubview(naVBarView)
        naVBarView.addSubview(centerImageTitleView)
        
        centerImageTitleView.snp.makeConstraints { make in
            make.top.equalTo(naVBarView.snp.top).inset(-50)
            make.left.equalTo(naVBarView.snp.left)
            make.right.equalTo(naVBarView.snp.right)
            make.bottom.equalTo(naVBarView.snp.bottom).offset(-5)
        }
        
        naVBarView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(movieListTableView)
        movieListTableView.snp.makeConstraints { make in
            make.top.equalTo(naVBarView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        movieListTableView.addSubview(errorTitle)
        errorTitle.snp.makeConstraints { make in
            make.center.equalTo(movieListTableView.snp.center)
        }
    }
    
    // MARK: Title and Image Navbar view
    private func centerImageTitleView(icon: UIImage, subTitle: String) -> UIView {
        
        let titleView = UIView()
        
        let imageIcon: UIImageView = {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            return $0
        }(UIImageView())
        
        let subTitleLabel: UILabel = {
            $0.font = kFont.EffraMediumRegular.of(size: 14)
            $0.textAlignment = .center
            $0.textColor = kColor.BrandColours.DarkGray.withAlphaComponent(0.6)
            return $0
        }(UILabel())
        
        imageIcon.image = icon
        subTitleLabel.text = subTitle

        lazy var  containerStackView: UIStackView = {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 4
            $0.isUserInteractionEnabled = true
            return $0
        }(UIStackView(arrangedSubviews: [imageIcon, subTitleLabel]))
        
        imageIcon.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        titleView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.center.equalTo(titleView.snp.center)
        }
        
        return titleView
        
    }
    

    lazy var refreshControl : UIRefreshControl = {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handlePullDownToRefresh), for: UIControl.Event.valueChanged)
        return $0
    }(UIRefreshControl(frame: .zero))
 
    
    private func navigationToDetailVC(movie: Movie) {
        let movieDetailVC = MovieDetailsViewController(movie: movie)
        movieDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    @objc private func handlePullDownToRefresh() {
        favouriteMovieViewViewModel.getFavorite(page: 1)
    }
    

}

extension FavoriteMoviesViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
       return movieResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell {
            let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
            cell.setUpImage(movie: movieResult[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: movieUnavailableCellIdentifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        favouriteMovieViewViewModel.pagination(index: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, movieResult) = favouriteMovieViewViewModel.numberofMovies()
        navigationToDetailVC(movie: movieResult[indexPath.row])
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
