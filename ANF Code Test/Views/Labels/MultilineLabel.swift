//
//  MultilineLabel.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//
import UIKit

/**
 Creates a multiline label by default with centered text
 */
final class MultilineLabel: UILabel {
    
    /// Default initializer
    init() {
        super.init(frame: .zero)
        numberOfLines = 0
        textAlignment = .center
    }
    
    /// Initializer for storyboard creation
    /// - Parameter coder: The coder passed along
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        numberOfLines = 0
        textAlignment = .center
    }
    
}
