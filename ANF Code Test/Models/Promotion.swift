//
//  Promotion.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//
import Foundation
import UIKit

/**
 The default `Promotion` object
 */
struct Promotion: Codable, Identifiable {
    
    /// The unique identifier of the promotion
    let id: UUID = UUID()
    
    /// The promotion title
    let title: String
    
    //  The remote image path found in the object to load
    let backgroundImagePath: String

    /// The default content that should be parsed out as actions
    let content: [PromotionContent]?
    
    /// The promotion message to disaply on the cell
    let promoMessage: String?
    
    /// The Top description text
    let topDescription: String?
    
    /// The Bottom description text
    let bottomDescription: String?
    
    /// When using a local image
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
