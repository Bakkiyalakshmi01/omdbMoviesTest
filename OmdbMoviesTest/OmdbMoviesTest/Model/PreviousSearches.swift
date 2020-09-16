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
    var selectedString : String = ""
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Conform to NSCoding
    
    required init(coder decoder: NSCoder) {
        searches = decoder.decodeObject(forKey: "searches") as? [String] ?? []
        selectedString = decoder.decodeObject(forKey: "selectedString") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(searches, forKey: "searches")
        aCoder.encode(selectedString, forKey: "selectedString")

    }
}
