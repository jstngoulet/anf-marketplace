//
//  ANFExplore.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 Explore Domain for the API
 */
final class ANFExplore: ANFDomain {
    
    /// Fetches the marketplace data and returns the provided results
    /// - Returns: The contract for the list of promotions
    class func getMarketplaceData() async throws -> CodeTestExploreDataResponse {
        let data = try await RESTClient.perform(
            request: CodeTestExploreDataRequest()
        )
        
        let response = CodeTestExploreDataResponse(
            promotions: try JSONDecoder().decode([Promotion].self, from: data)
        )
        
        return response
    }
}
