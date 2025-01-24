//
//  PromotionContent.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import Foundation

struct PromotionContent: Codable {
    let target: String
    let title: String
    let elementType: String?
    
    var targetURL: URL? {
        URL(string: target)
    }
}
