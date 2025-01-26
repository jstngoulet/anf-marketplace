//
//  ANFExplore.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

final class ANFExplore: ANFDomain {
    
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
