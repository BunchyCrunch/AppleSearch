//
//  SearchResult.swift
//  AppleSearch
//
//  Created by Josh Sparks on 10/3/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation

struct MusicTopLevelDict: Decodable {
    let results : [MusicSearchResult]
}

struct AppTopLevelDict: Decodable {
    let results : [AppSearchResult]
}
struct MusicSearchResult: Decodable {
    let artistName: String
    let trackName: String?
    let artworkUrl100: String?
}

struct AppSearchResult: Decodable {
    let trackName: String
    let description: String
    let artworkUrl100: String?
}
