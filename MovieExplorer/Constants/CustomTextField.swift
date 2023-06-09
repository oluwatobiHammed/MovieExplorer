//
//  CustomTextField.swift
//  MovieExplorer
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit

class CustomTextField: UITextField {
    
    
    var iconImageView: UIImageView?
    var secureButton: UIButton?
    var secureFieldEnableImage: UIImage?
    var secureFieldDisableImage: UIImage?
    var isValid = false
    
    init(iconImage: UIImage, isSecure: (secureFieldEnableImage: UIImage, secureFieldDisableImage: UIImage)? = nil) {
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

        
        if let secureFieldEnableImage = isSecure?.secureFieldEnableImage, let secureFieldDisableImage = isSecure?.secureFieldDisableImage {
            
            self.secureFieldEnableImage = secureFieldEnableImage
            self.secureFieldDisableImage = secureFieldDisableImage
            
            self.secureButton = UIButton(type: .system)
            secureButton?.setImage(secureFieldEnableImage.withRenderingMode(.alwaysOriginal), for: .normal)
            secureButton?.addTarget(self, action: #selector(handleVisibility), for: .touchUpInside)
            isSecureTextEntry = true
            
            addSubview(secureButton!)
            secureButton!.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
                make.right.equalToSuperview().offset(-5)
                make.width.equalTo(40)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Textfield Configuration
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: secureButton != nil ? 40 : 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: secureButton != nil ? 40 : 0))
    }
    
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder { _ = becomeFirstResponder() }
            self.secureButton?.setImage(isSecureTextEntry
                ? secureFieldEnableImage?.withRenderingMode(.alwaysOriginal)
                : secureFieldDisableImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        //if !isFirstResponder && isSecureTextEntry { text?.removeAll() }
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
