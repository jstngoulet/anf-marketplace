//
//  CGFloat+Ext.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

extension CGFloat {
    
    var insetValue: UIEdgeInsets{
        UIEdgeInsets(
            top: self,
            left: self,
            bottom: self,
            right:self
        )
    }
    
}
