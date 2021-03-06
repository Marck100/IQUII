//
//  ImageLoader.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import Foundation
import UIKit.UIImage


/// ImageLoaded class handles image loading from both caches and urls
final class ImageLoader {
    
    static let shared = ImageLoader()
    
    lazy private var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults.standard
        return userDefaults
    }()
    
    /// Loads image from cache is it's available or from url if it isn't
    /// - Parameters:
    ///   - url: image's url
    func loadImage(from url: URL, completionHandler: @escaping(UIImage?) -> Void) {
        
        //if cache is available loads image from userDefaults
        if let cache = userDefaults.loadImageCache(url.absoluteString) {
            completionHandler(imageFromCache(cache))
        } else {
            //fetch image using internet connection
            imageFromURL(url) { (image) in
                if let image = image, let data = image.pngData() {
                    self.userDefaults.addImageCache(data, path: url.absoluteString)
                }
                
                completionHandler(image)
            }
        }
        
    }
    
    private func imageFromCache(_ cache: ImageCache) -> UIImage? {
        let image = UIImage(data: cache)
        return image
    }
    
    private func imageFromURL(_ url: URL, completionHandler: @escaping(UIImage?) -> Void) {
        DispatchQueue.global().async {
            var image: UIImage?
            defer { completionHandler(image) }
            
            guard
                let data = try? Data(contentsOf: url),
                let loadedImage = UIImage(data: data)
            else { return }
            
            image = loadedImage
        }
    }
    
}
