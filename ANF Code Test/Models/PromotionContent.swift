//
//  PromotionContent.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import Foundation

struct PromotionContent: Codable, Identifiable {
    
    let id: UUID = UUID()
    
    let target: String
    let title: String
    let elementType: String?
    
    var targetURL: URL? {
        URL(string: target.strippedWebDataPrefix)
    }
    
    private enum CodingKeys: String, CodingKey {
        case target
        case title
        case elementType = "elementType"
    }
}
