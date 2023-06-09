//
//  ViewController.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    private let messageUnavailableCellIdentifier = "UnavailableCellIdentifier"
    private var movieList: DiscoverMovie?
    private var movieResult: [Discover] = []
    private var currentPage = 1
    private var query = ""
    
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
        let image = UIImage(named: .searchIcon)
        let textField = CustomTextField(iconImage: image.imageWithColor(tintColor: kColor.BrandColours.DarkGray))
        textField.backgroundColor = .clear
        textField.clipsToBounds = false
        textField.placeholder = "Search for movie"
        textField.textColor = kColor.BrandColours.DarkGray
        textField.font = kFont.EffraRegular.of(size: 15)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        $0.backgroundColor = .clear
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(handlePullDownToRefresh), for: UIControl.Event.valueChanged)
        return $0
    }(UIRefreshControl(frame: .zero))
    
    private let naVBarView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    @objc private func handlePullDownToRefresh() {

    }
    
    
    private (set) lazy var sendButton: UIButton = {
        let image = UIImage(named: .sendButton)
        $0.setImage(image.imageWithColor(tintColor: kColor.BrandColours.DarkGray), for: .normal)
        $0.addTarget(self, action: #selector(sendButtonnPressed), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let networkManager = NetworkManager()
    private lazy var movieListTableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: MovieDetailTableViewCell.reuseIdentifier)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: messageUnavailableCellIdentifier)
        $0.separatorStyle = .none
        $0.refreshControl = refreshControl
        $0.backgroundColor = kColor.BrandColours.Bizarre
        $0.contentInsetAdjustmentBehavior = .never
        $0.keyboardDismissMode = .interactive
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        $0.alwaysBounceVertical = true
        return $0
    }(UITableView())

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
    
    
    func setUpview() {
        let centerImageTitleView  = centerImageTitleView(title: "TMBD", subTitle: "Millions of movies TV shows and people to discover", tintColor: kColor.BrandColours.DarkGray)
        view.addSubview(naVBarView)
        naVBarView.addSubview(centerImageTitleView)
        
        centerImageTitleView.snp.makeConstraints { make in
            make.top.equalTo(naVBarView.snp.top).inset(-35)
            make.left.equalTo(naVBarView.snp.left)
            make.right.equalTo(naVBarView.snp.right)
            make.bottom.equalTo(naVBarView.snp.bottom)
        }
        
        naVBarView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(15)
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
    
    private func adjustKeyboard(bottomConstraint: CGFloat) {
        view.addSubview(inputViewContainerView)
        inputViewContainerView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().inset(bottomConstraint)
                make.height.equalTo(60)
            }
    
    }
    
    
    private func centerImageTitleView(title: String, subTitle: String, tintColor: UIColor) -> UIView {
        
        let titleView = UIView()
        
        let centeredTitleLabel: UILabel = {
            $0.font = kFont.EffraMediumRegular.of(size: 25)
            $0.textAlignment = .center
            $0.textColor = tintColor
            return $0
        }(UILabel())
        
        let subTitleLabel: UILabel = {
            $0.font = kFont.EffraMediumRegular.of(size: 14)
            $0.textAlignment = .center
            $0.textColor = kColor.BrandColours.DarkGray.withAlphaComponent(0.6)
            return $0
        }(UILabel())
        
        centeredTitleLabel.text = title
        subTitleLabel.text = subTitle

        lazy var  containerStackView: UIStackView = {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.isUserInteractionEnabled = true
            return $0
        }(UIStackView(arrangedSubviews: [centeredTitleLabel, subTitleLabel]))
        

        titleView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.center.equalTo(titleView.snp.center)
        }
        
        
        return titleView
        
    }
    
    func getQueryText(page: Int) {
        guard query != ""  else { return }
        
        networkManager.getSearch(page: page, query: query) { [weak self] movie, err in
            
            DispatchQueue.main.async { [weak self] in
                guard let self, let movie else {return}
                if movieList?.results.count ?? 0 < 1 {
                    movieList = movie
                    movieResult = Array(movie.results)
                } else {
                    movieList = movie
                    movieResult.append(contentsOf: movie.results)
                }
                
                movieListTableView.reloadData()
                searchTextField.text = ""
            }
            
        }
    }
    
    @objc private func sendButtonnPressed() {
        if currentPage > 1 {
            currentPage = 1
        }
        movieList = nil
        movieResult.removeAll()
        query = searchTextField.text ?? ""
        getQueryText(page: currentPage)
        searchTextField.endEditing(true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell {
            cell.setUpImage(movie:  movieResult[indexPath.row])
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: messageUnavailableCellIdentifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let totalPages = movieList?.totalPages, currentPage  < totalPages, indexPath.row == movieResult.count  - 1 {
                currentPage += 1
                
                getQueryText(page: currentPage)
            } 
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

