//
//  AttributedText.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/25/25.
//
import SwiftUI

struct AttributedText: UIViewRepresentable {
    
    private var fontSize: CGFloat = 13
    private var alignment: NSTextAlignment = .left
    private let attributedString: NSAttributedString
    private let linkActionDelegate: LinkActionDelegate = LinkActionDelegate()
    
    init(
        _ attributedString: NSAttributedString
        , fontSize: CGFloat = 13
        , textAlignment: NSTextAlignment = .left
    ) {
        self.attributedString = attributedString
        self.fontSize = 13
        self.alignment = textAlignment
    }
    
    func makeUIView(context: Context) -> UITextView {
        // Called the first time SwiftUI renders this "View".
        
        let uiTextView = UITextView()
        
        // Make it transparent so that background Views can shine through.
        uiTextView.backgroundColor = .clear
        
        // For text visualisation only, no editing.
        uiTextView.isEditable = false
        
        // Make UITextView flex to available width, but require height to fit its content.
        // Also disable scrolling so the UITextView will set its `intrinsicContentSize` to match its text content.
        uiTextView.isScrollEnabled = false
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiTextView.delegate = linkActionDelegate
        
        return uiTextView
    }
    
    func updateUIView(_ uiTextView: UITextView, context: Context) {
        // Called the first time SwiftUI renders this UIViewRepresentable,
        // and whenever SwiftUI is notified about changes to its state. E.g via a @State variable.
        //  First, set the mutable string from the original
        let mutableAttributed = NSMutableAttributedString(
            attributedString: attributedString
        )
        let range = NSRange(location: 0, length: mutableAttributed.length)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        //  Now, set the properties on the entire string for font size and the alignemtn
        mutableAttributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        mutableAttributed.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
        
        uiTextView.attributedText = mutableAttributed
    }
}

class LinkActionDelegate: NSObject, UITextViewDelegate {
    
    @available(iOS 17.0, *)
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        if case .link(let url) = textItem.content
            , let revisedURL = URL(string: url.absoluteString.strippedWebDataPrefix) {
            UIApplication.shared.open(revisedURL)
        }
        return nil
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        //  Do not perform both functions if on ios 17 or higher
        if #available(iOS 17, *) { return false }
        
        guard let updatedURL = NSURL(string: URL.absoluteString.strippedWebDataPrefix)?.absoluteURL
        else { return false }
        UIApplication.shared.open(updatedURL)
        return false
    }
}
