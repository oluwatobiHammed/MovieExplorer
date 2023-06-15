//
//  ViewController.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import UIKit
import SnapKit

class SearchMovieListViewController: BaseViewController {
    
    // MARK: Properties
    private let messageUnavailableCellIdentifier = "UnavailableCellIdentifier"
    private let image = UIImage(named: .searchIcon)
    private var networkManager = NetworkManager()
   
 
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
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        $0.isEnabled = false
        return $0
    }(UIButton())
        
    
    private lazy var movieViewViewModel: SearchedMovieViewModelProtocol = {
        return SearchedMovieViewModel(setView: self, networkManager: networkManager)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieViewViewModel.viewDidLoad()
        view.backgroundColor = .white
        setUpview()
    }
    
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: setUpview
    private func setUpview() {
        
        movieViewViewModel.getMovies()
       
        adjustKeyboard(bottomConstraint: tabBarHeight)
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
    override func adjustKeyboard(bottomConstraint: CGFloat) {
        view.addSubview(inputViewContainerView)
        inputViewContainerView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().inset(bottomConstraint)
                make.height.equalTo(60)
            }
    
    }
    
    
    override func hideSearchbar(isShown: Bool = true) {
        adjustKeyboard(bottomConstraint: isShown ? -tabBarHeight : tabBarHeight)
    }
    
  
 
    
    override func numberofMovies(total: Int = 0, movie: [Movie] = []) -> (Int, [Movie]) {
        return movieViewViewModel.numberofMovies()
    }
    
    override func pagination(index: Int) {
        movieViewViewModel.pagination(index: index)
    }
    
    @objc private func sendButtonnPressed() {
        movieViewViewModel.handleSendButton(query: searchTextField.text ?? "")
        searchTextField.endEditing(true)
    }
    
    @objc fileprivate func textFieldDidChange(textField: UITextField) {
        sendButton.isEnabled = !(textField.text?.isBlank ?? false)
        
    }
    

}



extension SearchMovieListViewController: SearchMovieListViewProtocol {
    func showAlert(title: String?, message: String) {
        AlertManager.sharedAlertManager.showAlertWithTitle(title: title ?? "", message: message, controller: self) {[weak self] _ in
            guard let self else {return}
            sendButton.isEnabled = false
            self.searchTextField.text = ""
        }
    }
    
    func reloadMovieTableView(sendButtonPressed: Bool) {
        checkLikedImageUpdate()
        movieListTableView.reloadData()
        if sendButtonPressed {
            movieListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        sendButton.isEnabled = false
        searchTextField.text = ""
        
    }
}



