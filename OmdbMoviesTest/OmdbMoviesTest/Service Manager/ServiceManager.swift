//
//  ServiceManager.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import Alamofire

class ServiceManager {
    private let base_url =  "https://www.omdbapi.com/?&h=600&apikey=94573e26"
    
    func fetchMovies(with string: String, completion: @escaping (SearchMovie?, Error?) -> ()) {
        let url = "\(base_url)&s=\(string)&type=movie"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers : nil).validate(statusCode: 200..<300).responseJSON { response in
            print(response)

            switch response.result {
            case .success(_):
                 do {
                   print(response)
                   let resp = try JSONDecoder().decode(SearchMovie?.self, from: response.data!)
                    completion(resp, nil)
                 } catch{
                    print("Could not parse json")
                 }
                break
            case .failure(let error):
                print(error)
                print(response)
                completion(nil, error)
                break
            }
        }
    }
}
