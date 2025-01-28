//
//  UIView+Ext.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

/**
 UIView Extension Helper
 */
public extension UIView {
    
    /// The default view offset to use, could be in constants file
    var viewOffset: CGFloat { 8 }
    
    /// The default button height to assign for the  cell. Could be in constants file
    var buttonHeight: CGFloat { 44 }
    
    /// Wrapper view to add multiple children at once within a parent
    /// - Parameter views: The children views to add, in order, to the parent
    func add(_ views: [UIView])
    { views.forEach({ self.addSubview($0) })}
    
}
