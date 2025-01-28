//
//  ANFClickableLabel.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import UIKit

/**
 Delegate to listen in on when a url is selected
 */
protocol ClickableLabelDelegate: NSObjectProtocol {
    func clicked(label: ANFClickableLabel, link: String)
}

/**
 Offer a label that allows user to click particular phrases (as hyrelinks) in the label
 */
class ANFClickableLabel: UIView {
    
    /// The primary subcontainer for the view.
    private(set) lazy var label: UITextView = {
       let lbl = UITextView()
        lbl.backgroundColor = .clear
        lbl.isEditable = false
        lbl.isSelectable = true
        lbl.isUserInteractionEnabled = true
        lbl.delegate = self
        lbl.dataDetectorTypes = .link
        lbl.isScrollEnabled = false
        lbl.tintColor = UIColor.lightGray
        lbl.textContainerInset = UIEdgeInsets.zero
        lbl.textContainer.lineFragmentPadding = 0
        lbl.accessibilityIdentifier = "clickableLabel"
        return lbl
    }()
    
    /// When the frme updates, so does the smaller label
    override var frame: CGRect {
        didSet {
            label.frame = bounds
        }
    }
    
    /// The link attributes for the current field
    var linkAttributes: [NSAttributedString.Key: Any]
    {
        get { label.linkTextAttributes }
        set { label.linkTextAttributes = newValue }
    }
    
    /// The attributed text of the current field
    var attributedText: NSAttributedString {
        label.attributedText ?? NSAttributedString()
    }
    
    /// The current delegate, listeing to actions on the label
    weak var delegate: ClickableLabelDelegate?
    
    /// Intiialize the view with constraints, instead of just frames
    /// - Parameter txt: The attributed text to display
    convenience init(
        withConstraintsAndText txt: NSAttributedString,
        qaTitle: String? = nil,
        qaIdentifier: String? = nil
    ) {
        self.init()
        setup()
        set(text: txt)
        
        accessibilityLabel = qaTitle
        accessibilityIdentifier = qaIdentifier
    }
    
    /// Default initializer
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    /// When initialized from storyboard
    /// - Parameter coder: The coder to init from (not used internally)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Wrapper function to setup the view, regardless of storyboard or default
    /// initializer
    private func setup() {
        build()
        
        //  Bound the text view to the parent
        label.pinToSuperview()
        layoutSubviews()
        updateConstraints()
    }
    
    /// Sets the text in the current view
    /// - Parameter text: The text to set
    func set(text: NSAttributedString) {
        let currentWidth = frame.width
        label.attributedText = text
        label.sizeToFit()
        label.frame.size.width = currentWidth
        frame.size = label.frame.size
    }
    
    deinit {
        delegate = nil
    }

}

//  MARK: - The listener to the clickable delegate
extension ANFClickableLabel: UITextViewDelegate {
    
    /// The URL that was selected
    /// - Parameters:
    ///   - textView:           The text view that was selected
    ///   - URL:                The URL that was clicked
    ///   - characterRange:     The character range of the URL that was selected
    ///   - interaction:        The interaction that was imposed on the view
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        
        if let stripped = NSURL(string: URL.absoluteString.strippedWebDataPrefix) {
            UIApplication.shared.open(stripped as URL)
        }
        
        //  Call the delegate, if used
        delegate?.clicked(label: self, link: URL.absoluteString)
        
        return false
    }
}

//  MARK: - Build and Construct the view
private extension ANFClickableLabel {
    
    /// Wrapper function to construct the view
    func build() {
        addSubviews()
    }
    
    /// Adds the subvies to the view
    func addSubviews() {
        add([label])
    }
    
}
