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
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    
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
    
    func setUpImage(url: String) {
        posterImage.kf.setImage(with: kAPI.Base_img_URL+url,
                                placeholder: #imageLiteral(resourceName: "Image_Placeholder"),
                                options: [.loadDiskFileSynchronously,
                                          .cacheOriginalImage,
                                          .diskCacheExpiration(.days(7)),
                                          .transition(.fade(0.5))])
    }
    
    private func setUpUI() {
     
        addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
