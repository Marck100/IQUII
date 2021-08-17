//
//  UserDefaults++.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import Foundation

typealias ImageCache = Data

extension UserDefaults {
    
    private static let cacheID = "com.userdefaults.cache"
    private static let searchResultCacheID = "com.userdefaults.cache"
    
    func addImageCache(_ cache: ImageCache, path: String) {
        var dictionary = self.dictionary(forKey: UserDefaults.cacheID) as? [String: ImageCache] ?? [:]
        dictionary.updateValue(cache, forKey: path)
        
        self.set(dictionary, forKey: UserDefaults.cacheID)
    }
    
    func loadImageCache(_ path: String) -> ImageCache? {
        let dictionary = self.dictionary(forKey: UserDefaults.cacheID) as? [String: ImageCache] ?? [:]
        
        return dictionary[path]
    }
    
    func addSearchResultCache(_ cache: SearchResultCache, keyword: String) {
        var dictionary = self.dictionary(forKey: UserDefaults.searchResultCacheID) as? [String: SearchResultCache] ?? [:]
        dictionary.updateValue(cache, forKey: keyword)
        
        self.set(dictionary, forKey: UserDefaults.searchResultCacheID)
    }
    
    func loadSearchResultCache(_ keyword: String) -> SearchResultCache? {
        let dictionary = self.dictionary(forKey: UserDefaults.searchResultCacheID) as? [String: SearchResultCache] ?? [:]
        return dictionary[keyword]
    }
    
}
