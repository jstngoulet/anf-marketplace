//
//  CGFloat+Ext.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

/**
 Extension for CGFloat to convert to an inset value for constraint layout
 */
extension CGFloat {
    
    /// Convert the single float value into an inset value
    var insetValue: UIEdgeInsets{
        UIEdgeInsets(
            top: self,
            left: self,
            bottom: self,
            right:self
        )
    }
    
}
