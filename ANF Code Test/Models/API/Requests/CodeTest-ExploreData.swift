//
//  CodeTest-ExploreData.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 The request for the list of promotions from the server
 */
final class CodeTestExploreDataRequest: ANFRequest {
    
    /// Initialize the request without any parameters (none required)
    init() {
        super.init(
            requestMethod: .get,
            path: "codeTest_exploreData.json",
            body: nil
        )
    }
}
