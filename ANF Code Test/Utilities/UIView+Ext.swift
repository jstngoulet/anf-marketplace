//
//  UIView+Ext.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

public extension UIView {
    
    var viewOffset: CGFloat { 8 }
    
    var buttonHeight: CGFloat { 44 }
    
    func add(_ views: [UIView])
    { views.forEach({ self.addSubview($0) })}
    
}
