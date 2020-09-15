//
//  PreviousSearches.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

class PreviousSearches: NSObject, NSCoding {
    
    // MARK: - Stored Properties
    
    var searches: [String] = []
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Conform to NSCoding
    
    required init(coder decoder: NSCoder) {
        searches = decoder.decodeObject(forKey: "searches") as? [String] ?? []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(searches, forKey: "searches")
    }
}
