//
//  String+isBlank.swift
//  MovieExplorer
//
//  Created by Oladipupo Oluwatobi on 09/06/2023.
//

import Foundation


import Foundation

extension String {
    
    var isBlank: Bool {
         return allSatisfy({ $0.isWhitespace })
     }
}
