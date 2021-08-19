//
//  IQUIITests.swift
//  IQUIITests
//
//  Created by Marco Pilloni on 19/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import XCTest
@testable import IQUII

class IQUIITests: XCTestCase {

    
    func testResultDecoding() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "ResultExample", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(RedditController.Result.self, from: data)
        
        XCTAssert(result.posts.isEmpty == false)
    }
    
    func testPostFetching() {
        
        let expectation = self.expectation(description: "Reddit controller fetched posts")
        
        let keyword = "Apple"
        RedditController.default.fetchPosts(keyword) { (posts) in
            XCTAssertTrue(posts != nil)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            guard let error = error else { return }
            XCTFail("waitForExpectations with error: \(error.localizedDescription)")
        }
    }
    
    func testPostFetchingPerformance() throws {
        
        measure {
            let expectation = self.expectation(description: "Reddit controller fetched posts")
            
            let keyword = "Apple"
            RedditController.default.fetchPosts(keyword) { (posts) in
                XCTAssertTrue(posts != nil)
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5) { (error) in
                guard let error = error else { return }
                XCTFail("waitForExpectations with error: \(error.localizedDescription)")
            }
        }
    }

}
