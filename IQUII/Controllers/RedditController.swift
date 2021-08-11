//
//  RedditController.swift
//  IQUII
//
//  Created by Marco Pilloni on 11/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import Foundation


final class RedditController {
    
    struct Result: Codable {
        
        var posts: [Post]
        var url: URL!
        
        enum ListingCodingKeys: CodingKey {
            case data
        }
        enum DataCodingKeys: CodingKey {
            case children
        }
        
        init(from decoder: Decoder) throws {
            let listingContainer = try decoder.container(keyedBy: ListingCodingKeys.self)
            let dataContainer = try listingContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
            
            let posts = try dataContainer.decode([Post].self, forKey: .children)
            self.posts = posts.filter { $0.imageURL.absoluteString.hasPrefix("https://") }
        }
        
        
    }
    
    private let basePath = "https://www.reddit.com/r/{KEYWORD}/top.json"
    
    static let `default` = RedditController()
    
    func fetchPosts(_ keyword: String, completionHandler: @escaping(([Post]?) -> Void)) {
        
        let path = basePath.replacingOccurrences(of: "{KEYWORD}", with: keyword)
        guard let url = URL(string: path) else {
            completionHandler(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var posts: [Post]? = nil
            defer { completionHandler(posts) }
            guard let data = data else { return }
            
            guard let result = try? JSONDecoder().decode(Result.self, from: data) else { return }
            posts = result.posts
            
        }.resume()
        
    }
    
}
