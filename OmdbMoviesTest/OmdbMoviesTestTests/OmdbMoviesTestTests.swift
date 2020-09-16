//
//  OmdbMoviesTestTests.swift
//  OmdbMoviesTestTests
//
//  Copyright © 2020 Test. All rights reserved.
//

import XCTest
@testable import OmdbMoviesTest

class OmdbMoviesTestTests: XCTestCase {
        
    func testSearchMovies() {
        let e = expectation(description: "Search for movies with man keyword")
        ServiceManager().fetchMovies(with: "man") {
            (moviesList, error) in
            XCTAssertTrue(moviesList?.response == "True")
            XCTAssertNil(error, "Error \(error!.localizedDescription)")
            e.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
