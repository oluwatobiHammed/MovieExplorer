//
//  StringExtensionsTests.swift
//  MovieExplorerTests
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation
@testable import MovieExplorer
import XCTest

final class ExtensionsTests: XCTestCase {
    
    func testifIsBlank() {
        let input = ""
        XCTAssertEqual(input.isBlank, true, "The String does not contain any Whitespace.")
    }
    
    func testColorhexString() {
        XCTAssertEqual(UIColor(hexString: "#2A83DF"), kColor.Bar.Background.FitnessBlue, "The color don't match")
    }
    
    func testDecodingExtension () {
        guard let encodedData = try? JSONEncoder().encode("new value") else { return }
        XCTAssertEqual("new value", try String.decode(data: encodedData), "The decoded data does not match.")
    }
    
    func testimageWithColor() {
        let image =  UIImage(named: .imagePlaceholder)
        let image1 =  UIImage(named: .imagePlaceholder)
        
        XCTAssertEqual(image,image1, "The image does not match")
    }
}
