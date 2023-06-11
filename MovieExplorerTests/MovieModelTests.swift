//
//  MovieModel.swift
//  MovieExplorerTests
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation
@testable import MovieExplorer
import XCTest

final class MovieModelTests: XCTestCase {
    
    private var sut: MovieViewModelProtocol!
    private var VCProtocol: MovieListViewProtocol!
    
    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        VCProtocol = MovieListViewController()
        sut = MovieViewModel(setView: VCProtocol, networkManager: MockNetworkManager())
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        /// When the Data initializer is throwing an error, the test will fail.
        VCProtocol = nil
        sut = nil
    }

    
    func testFirstNameNotEmpty() throws {
        
        let file = Bundle.main.url(forResource: "movies", withExtension: "json")!
        let jsonData = try Data(contentsOf: file)
        let movies = try? Movies.decode(data: jsonData)
        
        sut.handleSendButton(query: "superman")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
            let (total, movieResult) = sut.numberofMovies()
            XCTAssertEqual(total, movies?.totalPages, "not the same total count")
            XCTAssertEqual(movieResult.count, movies?.results.count, "not the same count of movies")
            XCTAssertEqual(movieResult.first?.originalTitle, movies?.results.first?.originalTitle, "not the same title of movies")
            XCTAssertEqual(movieResult.first?.backdropPath, movies?.results.first?.backdropPath, "not the same backdropPath of movies")
            XCTAssertEqual(movieResult.first?.id, movies?.results.first?.id, "not the same backdropPath of movies")
            XCTAssertEqual(movieResult.first?.overview, movies?.results.first?.overview, "not the same backdropPath of movies")
            XCTAssertEqual(movieResult.first?.popularity, movies?.results.first?.popularity, "not the same backdropPath of movies")
            XCTAssertEqual(movieResult.first?.voteAverage, movies?.results.first?.voteAverage, "not the same backdropPath of movies")
        })
        
    }
    
}

