//
//  SearchResultController.swift
//  AppleSearch
//
//  Created by Josh Sparks on 10/3/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import UIKit

struct StringConstants {
    fileprivate static let baseURL = "https://itunes.apple.com"
    fileprivate static let searchComponent = "search"
    fileprivate static let termKey = "term"
    fileprivate static let entityKey = "entity"
    fileprivate static let entityMusicValue = "musicTrack"
    fileprivate static let entityAppValue = "software"
}

class SearchResultController {
    
    static func getMusicItemsWith(searchText: String, completion: @escaping ([MusicSearchResult]) -> Void) {
        guard var baseURL = URL(string: StringConstants.baseURL) else {completion([]); return }
        baseURL.appendPathComponent(StringConstants.searchComponent)
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {completion([]); return }
        let searchTermQuery = URLQueryItem(name: StringConstants.termKey, value: searchText)
        let entityQuery = URLQueryItem(name: StringConstants.entityKey, value: StringConstants.entityMusicValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        guard let finalURL = components.url else {
            print("Components have an issue")
            completion([])
            return
        }
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("error retrieving the info from Apple: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data else {
                print("no data was received")
                completion([])
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let topLevelDict = try jsonDecoder.decode(MusicTopLevelDict.self, from: data)
                completion(topLevelDict.results)
            } catch {
                print("error decoding data")
            }
        } .resume()
    }
    
    static func getAppItemsWith(searchText: String, completion: @escaping ([AppSearchResult]) -> Void) {
        guard var baseURL = URL(string: StringConstants.baseURL) else {completion([]); return }
        baseURL.appendPathComponent(StringConstants.searchComponent)
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { completion([]); return }
        let searchTermQuery = URLQueryItem(name: StringConstants.termKey, value: searchText)
        let entityQuery = URLQueryItem(name: StringConstants.entityKey, value: StringConstants.entityAppValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        guard let finalURL = components.url else {
            print("Components have an issue")
            completion([])
            return
        }
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("error retrieving the info from Apple: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data else {
                print("no data was received")
                completion([])
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let topLevelDict = try jsonDecoder.decode(AppTopLevelDict.self, from: data)
                completion(topLevelDict.results)
            } catch {
                print("error decoding data")
            }
        } .resume()
    }
    
    static func getMusicImageFor(item: MusicSearchResult, completion: @escaping (UIImage?) -> Void) {
        guard let imageURLAsString = item.artworkUrl100,
            let url = URL(string: imageURLAsString) else {
                print("Item did not have an image available at url provided")
                completion(nil)
                return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                print("Could not retrieve data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        } .resume()
    }
    
    static func getAppImageFor(item: AppSearchResult, completion: @escaping (UIImage?) -> Void) {
        guard let imageURLAsString = item.artworkUrl100,
            let url = URL(string: imageURLAsString) else {
                print("Item did not have an image available at url provided")
                completion(nil)
                return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Could not retrieve data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        } .resume()
    }
} // end of class
