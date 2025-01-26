//
//  Promotion.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//
import Foundation
import UIKit

struct Promotion: Codable, Identifiable {
    
    let id: UUID = UUID()
    
    let title: String
    let backgroundImagePath: String
    let content: [PromotionContent]?
    let promoMessage: String?
    let topDescription: String?
    let bottomDescription: String?
    
    var localImage: UIImage?
    { UIImage(named: backgroundImagePath) }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case backgroundImagePath = "backgroundImage"
        case content
        case promoMessage
        case topDescription
        case bottomDescription
    }
}
