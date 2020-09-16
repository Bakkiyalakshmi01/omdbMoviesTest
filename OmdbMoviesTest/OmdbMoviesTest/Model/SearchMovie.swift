//
//  SearchMovie.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation

struct SearchMovie: Codable {
    let search: [Movie]
    let totalResults : String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

struct Movie: Codable {
    let title : String
    let year : String
    let imdbID : String
    let poster: String
    let type: Type
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

enum Type: String, Codable {
    case movie = "movie"
    case series = "series"
    case episode = "episode"
}
