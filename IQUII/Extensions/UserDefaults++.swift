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
    
    /// Save new image cache into userDefaults
    /// - Parameters:
    ///   - cache: image's data
    ///   - path: image's path
    func addImageCache(_ cache: ImageCache, path: String) {
        var dictionary = self.dictionary(forKey: UserDefaults.cacheID) as? [String: ImageCache] ?? [:]
        dictionary.updateValue(cache, forKey: path)
        
        self.set(dictionary, forKey: UserDefaults.cacheID)
    }
    
    
    /// Retrieve imageCache from a specific url
    /// - Parameter path: image's url
    func loadImageCache(_ path: String) -> ImageCache? {
        let dictionary = self.dictionary(forKey: UserDefaults.cacheID) as? [String: ImageCache] ?? [:]
        
        return dictionary[path]
    }
    
}
