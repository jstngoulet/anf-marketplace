//
//  CodeTest-ExploreData.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

final class CodeTestExploreDataRequest: ANFRequest {
    
    init() {
        super.init(
            requestMethod: .get,
            path: "codeTest_exploreData.json",
            body: nil
        )
    }
}
