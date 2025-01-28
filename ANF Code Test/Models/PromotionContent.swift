//
//  PromotionContent.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import Foundation

/**
 Promotion content object
 */
struct PromotionContent: Codable, Identifiable {
    
    /// ID assigned at initialization
    let id: UUID = UUID()
    
    /// Provided target URL (as string)
    let target: String
    
    /// Provided action target title
    let title: String
    
    /// The element type, when provided
    let elementType: ElementType?
    
    /// The target URL, parsed
    var targetURL: URL? {
        URL(string: target.strippedWebDataPrefix)
    }
    
    private enum CodingKeys: String, CodingKey {
        case target
        case title
        case elementType = "elementType"
    }
}


enum ElementType: String, Codable {
    case hyperlink
}
