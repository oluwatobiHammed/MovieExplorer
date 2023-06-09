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
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    let subTitleLabel: UILabel = {
        $0.font = kFont.EffraMediumRegular.of(size: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = kColor.BrandColours.DarkGray.withAlphaComponent(0.6)
        return $0
    }(UILabel())
    
    lazy var safeAreaView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white.withAlphaComponent(0.6)
        view.layer.cornerRadius = 15
        return view
    }()
    
    let centeredTitleLabel: UILabel = {
        $0.font = kFont.EffraBold.of(size: 20)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        //$0.textColor = tintColor
        return $0
    }(UILabel())

    lazy var containerStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.isUserInteractionEnabled = true
        return $0
    }(UIStackView(arrangedSubviews: [centeredTitleLabel, subTitleLabel]))
    
    
    
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
    
    func setUpImage(movie: Discover) {
        guard let urlString = movie.posterPath, let url = URL(string: kAPI.Base_img_URL+urlString) else { return }
        posterImage.kf.setImage(with:url,
                                placeholder: #imageLiteral(resourceName: "Image_Placeholder"),
                                options: [.loadDiskFileSynchronously,
                                          .cacheOriginalImage,
                                          .diskCacheExpiration(.days(7)),
                                          .transition(.fade(0.5))])
        centeredTitleLabel.text = movie.originalTitle
        subTitleLabel.text = movie.releaseDate
    }
    
    private func setUpUI() {
     addSubview(safeAreaView)
        
        safeAreaView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        safeAreaView.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(self.frame.width/2)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        safeAreaView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.left.equalTo(posterImage.snp.right).offset(10)
            make.bottom.equalTo(safeAreaView.snp.bottom).offset(-10)
            make.right.equalTo(safeAreaView.snp.right).offset(-10)
            make.height.equalTo(100)
        }
    }
}
