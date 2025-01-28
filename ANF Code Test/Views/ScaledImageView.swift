//
//  ScaledImageView.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//
import UIKit

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let image {
            let myImageWidth = image.size.width
            let myImageHeight = image.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return .zero
    }
    
}
