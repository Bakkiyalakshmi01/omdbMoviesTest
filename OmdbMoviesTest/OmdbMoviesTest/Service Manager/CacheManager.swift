//
//  CacheManager.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

enum Caching: Int {
    case previousSearches
}

class CacheManager: NSObject {
    
    // MARK: - Constants
    
    private static let keyPreviousSearches = "app.previousSearches"

    // MARK: - Stored Properties
    
    static var previousSearches: PreviousSearches = PreviousSearches()

    // MARK: - Initializers
    
    override private init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    static func store(cache: Caching) -> Void {
        switch cache {
        case .previousSearches:
            CacheService.archiveData(object: previousSearches as Any, key: keyPreviousSearches, isCodable: false)
        }
    }
    
    static func retreive(cache: Caching) -> Void {
        switch cache {
        case .previousSearches:
            if let data = Optional<PreviousSearches?>.some(CacheService.unarchiveData(key: keyPreviousSearches)) as? PreviousSearches {
                previousSearches = data
            } else {
               print("retreive - ERROR - couldn't load previous searches.")
            }
        }
    }
    
    static func remove(cache: Caching) -> Void {
        switch cache {
        case .previousSearches:
            CacheService.removeData(key: keyPreviousSearches)
        }
    }
    
    static func storeAll() -> Void {
        store(cache: .previousSearches)
    }
    
    static func retrieveAll() -> Void {
        retreive(cache: .previousSearches)
    }
    
    static func removeAll() -> Void {
        remove(cache: .previousSearches)
    }
}
