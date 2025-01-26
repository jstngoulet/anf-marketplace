//
//  CodeTestExploreDataResponse.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

struct CodeTestExploreDataResponse: ANFResponse {
    
    public enum CodeTestExploreResponseError: LocalizedError {
        case fileNotFound
    }
    
    var promotions: [Promotion]?
    
    var result: Result<any Codable, any Error> {
        return if let promotions {
            .success(promotions)
        } else {
            .failure(RESTClient.ANFRestClientError.badRequest)
        }
    }
    
    
}
