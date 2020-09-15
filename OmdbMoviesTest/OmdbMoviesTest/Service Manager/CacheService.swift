//
//  CacheService.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class CacheService: NSObject {
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods
    
    static func archiveData(object: Any, key: String) -> Void {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: key)
        } catch let error {
            print("archiveData - ERROR - \(key) couldn't store --> \(error.localizedDescription)")
        }
    }
    
    static func archiveData(object: Any, key: String, isCodable: Bool) -> Void {
        isCodable ? encodeData(object: object as Any, key: key) : archiveData(object: object, key:key)
    }
    
    static func unarchiveData<T>(key: String) -> T? {
        do {
            guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else {
                return nil
            }
            
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? T
        } catch let error {
            print("unarchiveData - ERROR - \(key) couldn't retreive --> \(error.localizedDescription)")
        }
        
        return nil
    }
    
    static func unarchiveData<T:Decodable>(key: String) -> T? {
        do {
            guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else {
                return nil
            }
            
            if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? Data {
                return try JSONDecoder().decode(T.self, from: data)
            }
        } catch let error {
            print("unarchiveData - ERROR - \(key) couldn't retreive --> \(error.localizedDescription)")
        }
        
        return nil
    }
    
    static func removeData(key: String) -> Void {
        guard (UserDefaults.standard.object(forKey: key) as? Data) != nil else {
            return
        }
        
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: - Private Methods
    
    private static func encodeData(object: Any, key: String) -> Void {
        do {
            let encoded = try JSONEncoder().encode(AnyEncodable(object as! Encodable))
            archiveData(object: encoded as Any, key: key)
        } catch let error {
            print("encodeData - ERROR - \(key) couldn't retreive --> \(error.localizedDescription)")
        }
    }
}

private struct AnyEncodable : Encodable {
    
    // MARK: - Stored Properties
    
    private var value: Encodable
    
    // MARK: - Initializers
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    // MARK: - Public Methods
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

extension Encodable {
    
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
