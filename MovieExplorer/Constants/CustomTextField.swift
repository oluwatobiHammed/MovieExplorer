//
//  CustomTextField.swift
//  MovieExplorer
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    
    var iconImageView: UIImageView?
    
    init(iconImage: UIImage) {
        super.init(frame: .zero)
        
        
        self.iconImageView = UIImageView(image: iconImage.withRenderingMode(.alwaysOriginal))
        iconImageView!.contentMode = .scaleAspectFit
        iconImageView!.tintColor = kColor.BrandColours.DarkGray
        
        addSubview(iconImageView!)
        
        iconImageView!.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(40)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Textfield Configuration
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 40))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 40))
    }
    
    
    override func becomeFirstResponder() -> Bool {
        
        let hasBecameFirstResponder = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return hasBecameFirstResponder
    }

    
    
    @objc func handleVisibility(sender: UIButton) {
        isSecureTextEntry.toggle()
    }
    
    
}
