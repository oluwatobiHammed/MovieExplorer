//
//  ViewController.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import UIKit
import SnapKit



protocol MovieListViewProtocol: AnyObject {
    func reloadMovieTableView(sendButtonPressed: Bool)
    func showAlert(title: String?, message: String)
}


class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    private let messageUnavailableCellIdentifier = "UnavailableCellIdentifier"
    private let image = UIImage(named: .searchIcon)
    
    private let inputViewContainerView: UIView = {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = .zero
        $0.layer.shadowRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.rasterizationScale = UIScreen.main.scale
        return $0
    }(UIView())
    
    lazy var searchTextField: CustomTextField = {
        $0.backgroundColor = .clear
        $0.clipsToBounds = false
        $0.attributedPlaceholder = NSAttributedString( string: "Search for movie", attributes: [NSAttributedString.Key.foregroundColor: kColor.BrandColours.DarkGray])
        $0.textColor = kColor.BrandColours.DarkGray
        $0.font = kFont.EffraRegular.of(size: 15)
        $0.returnKeyType = UIReturnKeyType.next
        return $0
    }(CustomTextField(iconImage: image.imageWithColor(tintColor: kColor.BrandColours.DarkGray)))
    
    
    private let naVBarView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    
    private (set) lazy var sendButton: UIButton = {
        let image = UIImage(named: .sendButton)
        $0.setImage(image.imageWithColor(tintColor: kColor.BrandColours.DarkGray), for: .normal)
        $0.addTarget(self, action: #selector(sendButtonnPressed), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var movieListTableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: MovieDetailTableViewCell.reuseIdentifier)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: messageUnavailableCellIdentifier)
        $0.separatorStyle = .none
        $0.backgroundColor = kColor.BrandColours.Bizarre
        $0.contentInsetAdjustmentBehavior = .never
        $0.keyboardDismissMode = .interactive
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        $0.alwaysBounceVertical = true
        return $0
    }(UITableView())
    
    
    private lazy var movieViewViewModel: MovieViewModelProtocol = {
        return MovieViewModel(setView: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupNotificationObservers()
        setUpview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: setUpview
    private func setUpview() {
        movieViewViewModel.getMovies()
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
       
    
        adjustKeyboard(bottomConstraint: 55)
        inputViewContainerView.addSubview(searchTextField)
        inputViewContainerView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.right.equalTo(inputViewContainerView.snp.right).inset(10)
            make.centerY.equalTo(searchTextField.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(inputViewContainerView.snp.left).inset(20)
            make.right.equalTo(sendButton.snp.left).inset(-12)
            make.top.equalTo(inputViewContainerView.snp.top).inset(7)
            make.bottom.equalTo(inputViewContainerView.snp.bottom)
            make.height.equalTo(50)

        }
    }
    
    // MARK: Keyboard Responses
    private func adjustKeyboard(bottomConstraint: CGFloat) {
        view.addSubview(inputViewContainerView)
        inputViewContainerView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().inset(bottomConstraint)
                make.height.equalTo(60)
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
    
    
    @objc private func sendButtonnPressed() {
        movieViewViewModel.handleSendButton(query: searchTextField.text ?? "")
        searchTextField.endEditing(true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let (_, movieResult) = movieViewViewModel.numberofMovies()
       return movieResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell {
            let (_, movieResult) = movieViewViewModel.numberofMovies()
            cell.setUpImage(movie: movieResult[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: messageUnavailableCellIdentifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        movieViewViewModel.pagination(index: indexPath.row)
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        
        let keyboardData = keyboardInfoFromNotification(notification)
        
        adjustKeyboard(bottomConstraint: 55)
        weak var weakSelf = self
        UIView.animate(withDuration: keyboardData.animationDuration,
                       delay: 0,
                       options: keyboardData.animationCurve,
                       animations: {
                        weakSelf?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        
        let keyboardData = keyboardInfoFromNotification(notification)
        adjustKeyboard(bottomConstraint: keyboardData.endFrame.height + 5)
        
        weak var weakSelf = self
        UIView.animate(withDuration: keyboardData.animationDuration,
                       delay: 0,
                       options: keyboardData.animationCurve,
                       animations: {
            weakSelf?.view.layoutIfNeeded()
        }, completion: nil)
     
    }
    

}


extension MovieListViewController: MovieListViewProtocol {
    func showAlert(title: String?, message: String) {
        AlertManager.sharedAlertManager.showAlertWithTitle(title: title ?? "", message: message, controller: self)
    }
    
    func reloadMovieTableView(sendButtonPressed: Bool) {
        movieListTableView.reloadData()
        if sendButtonPressed {
            movieListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        searchTextField.text = ""
    }
}
