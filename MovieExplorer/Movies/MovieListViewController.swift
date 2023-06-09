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
    private var movieList: [Discover] = []
    
    private let inputViewContainerView: UIView = {
        $0.backgroundColor = kColor.BrandColours.Bizarre
        return $0
    }(UIView())
    

    
    lazy var searchTextField: CustomTextField = {
        let image = UIImage(named: .searchIcon)
        let textField = CustomTextField(iconImage: image.imageWithColor(tintColor: kColor.BrandColours.DarkGray))
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = false
        textField.placeholder = "Search for movie, tv show, person..."
        textField.textColor = kColor.BrandColours.DarkGray
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        textField.font = kFont.EffraRegular.of(size: 15)
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 10
        textField.layer.shouldRasterize = true
        textField.layer.rasterizationScale = UIScreen.main.scale
        textField.autocapitalizationType = .none
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

        
        let centerImageTitleView  = centerImageTitleView(title: "TMBD", subTitle: "Millions of movies TV shows and people to discover", tintColor: kColor.BrandColours.DarkGray)
        view.addSubview(naVBarView)
        view.addSubview(inputViewContainerView)
        naVBarView.addSubview(centerImageTitleView)
        
        centerImageTitleView.snp.makeConstraints { make in
            make.top.equalTo(naVBarView.snp.top).offset(15)
            make.left.equalTo(naVBarView.snp.left)
            make.right.equalTo(naVBarView.snp.right)
            make.bottom.equalTo(naVBarView.snp.bottom)
        }
        
        naVBarView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(inputViewContainerView.snp.top)
            make.height.equalTo(80)
        }
        
       
        inputViewContainerView.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(100)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
        
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
        
        view.addSubview(movieListTableView)
        movieListTableView.snp.makeConstraints { make in
            make.top.equalTo(inputViewContainerView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
    
    @objc private func sendButtonnPressed() {
        
        guard let query = searchTextField.text, query != ""  else { return }
        networkManager.getSearch(page: 1, query: query) { [weak self] movie, err in
            
            DispatchQueue.main.async { [weak self] in
                guard let self, let movie else {return}
                movieList = Array(movie.results)
                movieListTableView.reloadData()
                searchTextField.text = ""
            }
            
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell {
            cell.setUpImage(movie:movieList[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: messageUnavailableCellIdentifier, for: indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}

