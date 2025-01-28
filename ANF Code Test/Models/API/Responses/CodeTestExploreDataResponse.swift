//
//  CodeTestExploreDataResponse.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 The possible response to the data from the server.
 Contract for provided request
 */
struct CodeTestExploreDataResponse: ANFResponse {
    
    /// List of promotions found
    var promotions: [Promotion]?
    
    /// Parse the list of promotions to a result to use
    var result: Result<any Codable, any Error> {
        return if let promotions {
            .success(promotions)
        } else {
            .failure(RESTClient.ANFRestClientError.badRequest)
        }
    }
    
    
}
