//
//  Post.swift
//  IQUII
//
//  Created by Marco Pilloni on 11/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import Foundation
import UIKit.UIImage


struct Post: Codable, Equatable {
    
    enum DecodingError: Error {
        case invalidPhotoURL
    }
    
    var imageURL: URL!
    var title: String
    
    var subreddit: String
    
    enum ChildrenCodingKeys: CodingKey {
        case data
    }
    enum DataCodingKeys: CodingKey {
        case subreddit, title, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let childrenContainer = try decoder.container(keyedBy: ChildrenCodingKeys.self)
        
        let container = try childrenContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        let imagePath = try container.decode(String.self, forKey: .thumbnail)
        
        guard let imageURL = URL(string: imagePath) else {
            throw DecodingError.invalidPhotoURL
        }
        
        self.imageURL = imageURL
        title = try container.decode(String.self, forKey: .title)
        subreddit = try container.decode(String.self, forKey: .subreddit)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DataCodingKeys.self)
        
        try container.encode(imageURL.absoluteString, forKey: .thumbnail)
        try container.encode(title, forKey: .title)
        try container.encode(subreddit, forKey: .subreddit)
    }
    
}
