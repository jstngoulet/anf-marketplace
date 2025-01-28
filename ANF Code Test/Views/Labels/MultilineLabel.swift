//
//  MultilineLabel.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//
import UIKit

final class MultilineLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        numberOfLines = 0
        textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
