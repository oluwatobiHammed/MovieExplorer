//
//  MovieDetailsViewController.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    
    private var movie: Movie
    private var starsRating: Int?
    private var networkManager = NetworkManager()
    private var listOfLiked =  UserManager().readSkippedContent()
    private let likebuttonimage = UIImage(named: .heartFill)
    private var isfavorite: Bool = false
    private let posterImage: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let mainContentContainer: UIView = {
        $0.backgroundColor = UIColor(hexString: "#A4000000", alpha: 0.1)
        $0.isOpaque = false
        return $0
    }(UIView(frame: .zero))
    
    private let contentContainer: UIView = {
        $0.backgroundColor = .clear
        return $0
    }(UIView(frame: .zero))
    
    private let topcontentContainer: UIView = {
        $0.backgroundColor = .clear
        return $0
    }( UIView(frame: .zero))
    
    private let firstLineViewContainer: UIView = {
        $0.backgroundColor =  kColor.BrandColours.DarkGray
        return $0
    }(UIView(frame: .zero))
    
    private let secondLineViewContainer: UIView = {
        $0.backgroundColor =  kColor.BrandColours.DarkGray
        return $0
    }(UIView(frame: .zero))
    
    private let rateLabel: UILabel = {
        $0.font = kFont.EffraMediumRegular.of(size: 18)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = kColor.BrandColours.DarkGray
        return $0
    }(UILabel())
    
    private let overViewLabel: UILabel = {
        $0.font = kFont.EffraRegular.of(size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = kColor.BrandColours.DarkGray
        $0.adjustsFontForContentSizeCategory = true
        $0.minimumScaleFactor = 0.4
        $0.adjustsFontSizeToFitWidth = true
        $0.sizeToFit()
        return $0
    }(UILabel())
    
    private let releasedateTitleLabel: UILabel = {
        $0.font = kFont.EffraRegular.of(size: 12)
        $0.text = "Release Date"
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = kColor.BrandColours.DarkGray.withAlphaComponent(0.5)
        return $0
    }(UILabel())
    
    private let releasedateLabel: UILabel = {
        $0.font = kFont.EffraHeavyRegular.of(size: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = kColor.BrandColours.DarkGray
        return $0
    }(UILabel())
    
    
    private lazy var containerStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
        $0.alignment = .fill
        return $0
    }(UIStackView(arrangedSubviews: [topcontentContainer, contentContainer]))
    
    private lazy var releaseDatecontainerStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
        $0.alignment = .fill
        $0.spacing = -60
        return $0
    }(UIStackView(arrangedSubviews: [releasedateTitleLabel, releasedateLabel]))
    
    
    private let circleImage: UIImageView = {
        let image = UIImage(named: .circle).imageWithColor(tintColor: UIColor.hexString("FFCA28"))
        $0.contentMode = .scaleAspectFit
        $0.image = image
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let ratingbuttonsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 5
        $0.isUserInteractionEnabled = true
        return $0
    }(UIStackView(frame: .zero))
    
    private (set) lazy var likeButton: UIButton = {
        $0.addTarget(self, action: #selector(likedButtonnPressed), for: .touchUpInside)
        $0.imageView?.contentMode = .scaleAspectFit
        return $0
    }(UIButton())
    
    private lazy var ratingImages = [UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    
    
    private lazy var moviedetailsViewViewModel: DetailMovieViewModelProtocol = {
        return DetailMovieViewModel(setView: self, networkManager: networkManager)
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        setUpPoster()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUpview()
        
    }
    
    
    private func setUpPoster() {
        let image = UIImage(named: .imagePlaceholder)
        let imgUrl = movie.posterPath ?? ""
        posterImage.kf.setImage(with:URL(string: kAPI.Base_img_URL+imgUrl),
                                placeholder: image,
                                options: [.loadDiskFileSynchronously,
                                          .cacheOriginalImage,
                                          .diskCacheExpiration(.days(7)),
                                          .transition(.fade(0.5))]) { _ in
                                              self.view.layoutIfNeeded()
                                          }
        
        overViewLabel.text =  movie.overview != "" ? movie.overview : "No details available for this movie"
        rateLabel.text = String(format: "%0.1f", movie.voteAverage)
        releasedateLabel.text = movie.releaseDate
        setStarsRating(rating: Int(movie.voteAverage)/2)
        print("listOfLiked", listOfLiked)
        isfavorite = listOfLiked.contains(where: { $0 == movie.id })
        likeButton.setImage( likebuttonimage.imageWithColor(tintColor: isfavorite ? .red : .white), for: .normal)
        
        
        
    }
    
    
    // MARK: - Set Up starRatingView
    private func setUpstarRatingView() {
        var starTag = 1
        ratingImages.forEach {
            $0.tag = starTag
            starTag = starTag + 1
            $0.contentMode = .scaleAspectFit
            ratingbuttonsStackView.addArrangedSubview($0)
        }
    }
    
    func setStarsRating(rating: Int) {
        self.starsRating = rating
        let stackSubViews = ratingbuttonsStackView.subviews.filter{$0 is UIImageView}
        stackSubViews.forEach {
            if let imageView = $0 as? UIImageView {
                let image = UIImage(named:  imageView.tag > starsRating ?? 1 ? .starEmpty : .starFilled).withTintColor(UIColor.hexString("FFCA28"))
                imageView.image = image
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainContentContainer.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        posterImage.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    
    private func setUpview() {
        
        setUpstarRatingView()
        view.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        view.addSubview(mainContentContainer)
        mainContentContainer.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        mainContentContainer.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(mainContentContainer.snp.top)
            make.left.equalTo(mainContentContainer.snp.left).offset(30)
            make.right.equalTo(mainContentContainer.snp.right).offset(-30)
            make.bottom.equalTo(mainContentContainer.snp.bottom).offset(-30)
            make.height.equalTo(200)
        }
        
        
        topcontentContainer.addSubview(circleImage)
        circleImage.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(topcontentContainer.snp.left)
            make.top.equalTo(topcontentContainer.snp.top)
            make.bottom.equalTo(topcontentContainer.snp.bottom)
        }
        
        topcontentContainer.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.center.equalTo(circleImage.snp.center)
        }
        
        topcontentContainer.addSubview(ratingbuttonsStackView)
        ratingbuttonsStackView.snp.makeConstraints { make in
            make.left.equalTo(circleImage.snp.right).offset(10)
            make.top.equalTo(topcontentContainer.snp.top)
            make.bottom.equalTo(topcontentContainer.snp.bottom).offset(10)
            make.width.equalTo(100)
        }
        
        topcontentContainer.addSubview(releaseDatecontainerStackView)
        releaseDatecontainerStackView.snp.makeConstraints { make in
            make.right.equalTo(topcontentContainer.snp.right)
            make.top.equalTo(topcontentContainer.snp.top)
            make.bottom.equalTo(topcontentContainer.snp.bottom)
        }
        
        contentContainer.addSubview(overViewLabel)
        overViewLabel.snp.makeConstraints { make in
            make.left.equalTo(contentContainer.snp.left)
            make.right.equalTo(contentContainer.snp.right)
            make.height.equalTo(60)
        }
        
        contentContainer.addSubview(firstLineViewContainer)
        firstLineViewContainer.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(overViewLabel.snp.bottom).offset(20)
            make.left.equalTo(contentContainer.snp.left)
            make.right.equalTo(contentContainer.snp.right)
            make.bottom.equalTo(contentContainer.snp.bottom)
        }
        
        contentContainer.addSubview(secondLineViewContainer)
        secondLineViewContainer.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(contentContainer.snp.left)
            make.right.equalTo(contentContainer.snp.right)
            make.bottom.equalTo(overViewLabel.snp.top).offset(-20)
        }
        
        
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.right.equalTo(posterImage.snp.right).offset(-10)
            make.bottom.equalTo(posterImage.snp.bottom).offset(-10)
        }
        
        
    }
    
    @objc private func likedButtonnPressed() {
        isfavorite = !isfavorite
        moviedetailsViewViewModel.addFavoiteMovie(movieId: movie.id, isfavorite: isfavorite)
        
        
    }
}

extension MovieDetailsViewController: DetailMovieViewProtocol {
    func updateLikeButton(isfavorite: Bool) {
        likeButton.setImage(likebuttonimage.imageWithColor(tintColor: isfavorite ? .red : .white), for: .normal)
    }
    
    func showAlert(title: String?, message: String) {
        AlertManager.sharedAlertManager.showAlertWithTitle(title: title ?? "", message: message, controller: self)
    }

}
