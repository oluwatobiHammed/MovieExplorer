//
//  MovieDetailTableViewCell.swift
//  MovieExplorer
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit
import Kingfisher

class MovieDetailTableViewCell:  UITableViewCell {
    
    static let reuseIdentifier = "MovieDetailCellIdentifier"
    
    private let posterImage: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.cornerRadiusLayer = 5
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    let rateImageView: UIImageView = {
        let image = UIImage(named: .starfill)
        $0.image = image
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        return $0
    }(UIImageView(frame: .zero))
    
    let rateLabel: UILabel = {
        $0.font = kFont.EffraMediumRegular.of(size: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = kColor.BrandColours.DarkGray
        return $0
    }(UILabel())
    
    lazy var safeAreaView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white.withAlphaComponent(0.6)
        return view
    }()
    
    let centeredTitleLabel: UILabel = {
        $0.font = kFont.EffraBold.of(size: 20)
        $0.textAlignment = .left
        $0.numberOfLines = 3
        $0.textColor = kColor.BrandColours.DarkGray
        return $0
    }(UILabel())
    
    let overViewTitleLabel: UILabel = {
        $0.font = kFont.EffraBold.of(size: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 5
        $0.textColor = kColor.BrandColours.DarkGray.withAlphaComponent(0.8)
        return $0
    }(UILabel())

    lazy var containerStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = -5
        return $0
    }(UIStackView(arrangedSubviews: [centeredTitleLabel, overViewTitleLabel]))
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        clipsToBounds = true
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpImage(movie: Movie) {
        
        let image = UIImage(named: .imagePlaceholder)
        let imgUrl = movie.posterPath ?? ""
        posterImage.kf.setImage(with:URL(string: kAPI.Base_img_URL+imgUrl),
                                placeholder: image,
                                options: [.loadDiskFileSynchronously,
                                          .cacheOriginalImage,
                                          .diskCacheExpiration(.days(7)),
                                          .transition(.fade(0.5))]) { _ in
                                              self.layoutIfNeeded()
                                          }
        
        centeredTitleLabel.text = movie.originalTitle
        rateLabel.text = String(format: "%0.1f", movie.voteAverage)
        rateImageView.isHidden = (movie.originalTitle == nil)
        overViewTitleLabel.text = movie.overview
    }
    
    private func setUpUI() {
     addSubview(safeAreaView)
        safeAreaView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        safeAreaView.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.left.equalTo(safeAreaView.snp.left).offset(10)
            make.width.equalTo(self.frame.width / 2)
            make.top.equalTo(safeAreaView.snp.top).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
        }
        
        safeAreaView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.left.equalTo(posterImage.snp.right).offset(10)
            make.right.equalTo(safeAreaView.snp.right).offset(-10)
            make.top.equalTo(safeAreaView.snp.top).offset(10)
        }
        safeAreaView.addSubview(rateImageView)
        rateImageView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.left.equalTo(posterImage.snp.right).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.top.equalTo(containerStackView.snp.bottom).offset(15)
        }
        
        safeAreaView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.left.equalTo(rateImageView.snp.right).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-8)
            make.top.equalTo(containerStackView.snp.bottom).offset(15)
            make.right.equalTo(safeAreaView.snp.right).offset(-10)
        }
    }
}
