//
//  ANFButton.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/27/25.
//

import UIKit

/**
 Protocol for when the button is selected, so that the action is handled internally
 but passed along to whichever class is listening (wrappers can enable multiple classes
 to listen, and even trigger reactive events)
 */
protocol ANFButtonSelected: AnyObject {
    func button(selected: ANFButton, parent: UIView)
}

/**
 Primary button class for a ANF button design, per spec
 */
class ANFButton: UIButton {
    
    /// Delegate, when the button is selected
    weak var delegate: ANFButtonSelected?
    
    /// Init the button with a title, accessibility identifer, accessibilty title and a delegate
    /// - Parameters:
    ///   - title:              The text to read on the cell
    ///   - localizedId:        The identifier of the element
    ///   - localizationTitle:  The title of the element
    ///   - delegate:           The delegate listening to the button actions
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
    
    /// When init from storyboard, should also assign action and delegate
    /// - Parameter coder:      The coder to pass along to super
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addTarget(
            self, action: #selector(handleTap),
            for: .touchUpInside
        )
        
        applyStyle()
    }
    
    /// Apply the ßtyle to the button, per spec
    private func applyStyle() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        
        setTitleColor(.gray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    }
}

//  MARK: - Actions
extension ANFButton {
    
    /// Handle the tap of the view
    @IBAction
    func handleTap() {
        guard let delegate, let superview else { return }
        print("Identifier: \(self.accessibilityIdentifier ?? "No Identifier")")
        delegate.button(selected: self, parent: superview)
    }
}
    

