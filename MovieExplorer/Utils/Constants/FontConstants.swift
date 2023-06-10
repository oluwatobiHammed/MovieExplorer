//
//  FontConstants.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import UIKit


enum kFont: String {

    case EffraBold = "Effra-Bold"
    case EffraItalic = "Effra-Italic"
    case EffraRegular = "Effra-Regular"
    case EffraBoldItalic = "Effra-BoldItalic"
    
    case EffraHeavyItalic = "EffraHeavy-Italic"
    case EffraHeavyRegular = "EffraHeavy-Regular"
    
    case EffraMediumRegular = "EffraMedium-Regular"
    case EffraMediumItalic = "EffraMedium-Italic"
    
    case EffraLightItalic = "EffraLight-Italic"
    case EffraLightRegular = "EffraLight-Regular"
    
    
    case UniversLight = "Univers-Light"
    
    case Digital7 = "Digital-7"


    
    public func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }

    static let homeSectionTitle = kFont.EffraRegular.of(size: 14)

}

