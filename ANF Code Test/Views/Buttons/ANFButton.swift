//
//  ANFButton.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

protocol ANFButtonSelected: AnyObject {
    func button(selected: ANFButton, parent: UIView)
}

class ANFButton: UIButton {
    
    weak var delegate: ANFButtonSelected?
    
    init(
        withTitle title: String
        , localizedId: String? = nil
        , localizationTitle: String? = nil
        , delegate: ANFButtonSelected? = nil
    ) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        accessibilityIdentifier = localizedId
        accessibilityLabel = localizationTitle
        
        self.addTarget(
            self, action: #selector(handleTap),
            for: .touchUpInside
        )
        self.delegate = delegate
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addTarget(
            self, action: #selector(handleTap),
            for: .touchUpInside
        )
        
        applyStyle()
    }
    
    private func applyStyle() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }
}

extension ANFButton {
    
    @objc func handleTap() {
        guard let delegate, let superview else { return }
        delegate.button(selected: self, parent: superview)
    }
}
    

