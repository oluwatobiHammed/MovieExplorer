//
//  HomeTabSelectorCell.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit

class HomeTabSelectorCell: UICollectionViewCell {
    
    override var canBecomeFocused: Bool {
        return false
    }
    
    override var isSelected: Bool {
        didSet {
            itemSelected(selected: isSelected)
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Undefined Title"
        label.textColor = kColor.BrandColours.Pink
        //label.font = kFont.EffraMediumRegular.of(size: 14)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemSelected(selected: false)
        
//        addSubview(titleLabel)
//        titleLabel.anchor(top: topAnchor,
//                          left: leftAnchor,
//                          bottom: bottomAnchor,
//                          right: rightAnchor,
//                          paddingTop: 5,
//                          paddingLeft: 12,
//                          paddingBottom: 5,
//                          paddingRight: 12,
//                          width: 0,
//                          height: 0)
        
    }
    
    func itemSelected(selected: Bool) {
        titleLabel.textColor = isSelected ? .white : kColor.BrandColours.DarkGray.withAlphaComponent(0.5)
        titleLabel.font = isSelected ? kFont.EffraMediumRegular.of(size: 14) : kFont.EffraRegular.of(size: 14)
        backgroundColor = isSelected ? kColor.BrandColours.DarkGray : .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
        
    }
    
}
