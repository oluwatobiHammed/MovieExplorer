//
//  UIImage+ImageName.swift
//  MovieExplorer
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//


import UIKit

extension UIImage {
    
    convenience init(named imageName: ImageName) {
        self.init(named: imageName.rawValue)!
    }
    
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
          UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

          let context = UIGraphicsGetCurrentContext()!
          context.translateBy(x: 0, y: self.size.height)
          context.scaleBy(x: 1.0, y: -1.0);
          context.setBlendMode(.normal)

          let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
          context.clip(to: rect, mask: self.cgImage!)
          tintColor.setFill()
          context.fill(rect)

          let newImage = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()

          return newImage
      }
}


enum ImageName: String {
    case sendButton = "send_icon"
    case searchIcon = "search-icon"
    case starfill = "star_fill"
    case imagePlaceholder = "Image_Placeholder"
    case tipsPlaceholder = "tips_placeholder"
    case tmdb
    case darktmdb
    case circle
    case back
    case heart
    case starEmpty = "star_empty"
    case starFilled = "star_filled"
}
