//
//  ExploreMarketplaceCell.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import UIKit

/**
 Primary cell to dynamically load content based ono available attributes
 
 Due to various cell types, constraints are handled internally to make the view
 dynamic and still support a variety of layouts. The views are available in the
 storyboard, however, since the constraints are dynamic based on available views,
 they are all altered here before and after image load
 */
class ExploreMarketplaceCell: UITableViewCell {
    
    /// The primary image view, scaled to height after load
    @IBOutlet
    private weak var primaryImageView: UIImageView!
    
    /// The Top DEscription label, above the title, but below the image
    @IBOutlet
    private weak var topDescriptionLabel: MultilineLabel!
    
    /// The primary title, the largest font, directly below the top description
    @IBOutlet
    private weak var titleLabel: MultilineLabel!
    
    /// The promo message label, smallest font, right below the title
    @IBOutlet
    private weak var promoMessageLabel: MultilineLabel!
    
    /// The bottom description label. This is a `ANFClickableLabel` as the
    /// view is interactable with links and associated actions
    @IBOutlet
    private weak var bottomDescriptionLabel: ANFClickableLabel!
    
    /// The primary content stack, at the bottom of the view when shown,
    /// is used to house th various content actions that may come with the content
    @IBOutlet
    private weak var contentStack: UIStackView!
    
    /// Array to manage the  variable constraints based on the layout.
    /// Reset when layout is re-rendered.
    private var activeConstraints: [NSLayoutConstraint] = []
    
    /// To keep track of the previous view to stack the next one directly under
    /// Is also used as the last view to pin to the bottom of the cell
    private lazy var lastView: UIView = primaryImageView
    
    /// Default top insets, used for stacking
    private var topInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: viewOffset/2,
            left: 0,
            bottom: viewOffset,
            right: 0
        )
    }
    
    /// Insets to use when there should be extra space between the last view and current
    private var doubleTopInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: viewOffset*2,
            left: 0,
            bottom: viewOffset,
            right: 0
        )
    }
    
    /// The current promotion displayed
    var promotion: Promotion?
    
    /// When awoken from nib, set the default selection style
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    /// When about to be reused, clear the image view and promotion
    override func prepareForReuse() {
        super.prepareForReuse()
        primaryImageView.image = nil
        promotion = nil
    }
}

//  MARK: - Public Accessors
extension ExploreMarketplaceCell {
    
    /// Sets the current promotion on the cell and updates the constraints and associated actions
    /// - Parameter promotion: The promotion object to set on the view
    func set(promotion: Promotion) {
        
        contentStack.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        
        set(imagePath: promotion.backgroundImagePath)
        set(topDescroption: promotion.topDescription)
        set(title: promotion.title)
        set(promoMessage: promotion.promoMessage)
        set(bottomDescription: promotion.bottomDescription)
        set(content: promotion.content)
        
        setPrimaryConstraints()
        updateConstraints()
        layoutSubviews()
        
        self.promotion = promotion
    }
    
}

//  MARK: - Private functions to update the cell content from wrapper
private extension ExploreMarketplaceCell {
    
    /// Sets the image path on the view
    /// - Note:                 Could support a placeholder in future
    /// - Parameter imagePath:  The remote path to set on the view
    func set(imagePath: String) {
        guard let url = URL(string: imagePath)
        else { return }
        
        primaryImageView.downloadImage(
            with: UIImage(named: "anf-20160527-app-m-shirts"),
            imageUrl: url,
            animationOptions: ImageAnimationOptions(
                duration: 0.5,
                options: [
                    .transitionCrossDissolve,
                    .beginFromCurrentState
                ]
            )
        ) { [weak self] result in
            guard let self
                , (try? result.get()) != nil
            else { return }
            
            DispatchQueue.main.async {
                self.setPrimaryConstraints()
            }
        }
    }
    
    /// Sets the top description label text. Hides if empty
    /// - Parameter topDescroption: The text to set on the top description.
    func set(topDescroption: String?) {
        topDescriptionLabel.text = topDescroption
        topDescriptionLabel.isHidden = topDescroption == nil
    }
    
    /// Sets the title on the title label
    /// - Parameter title: The title of the promotion
    func set(title: String) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
    }
    
    /// Sets the promo message on the cell. Hides if empty
    /// - Parameter promoMessage: The promo message to set
    func set(promoMessage: String?) {
        promoMessageLabel.text = promoMessage
        promoMessageLabel.isHidden = promoMessage == nil
    }
    
    /// Sets the bottom description on the cell. Hides if empty
    /// - Parameter bottomDescription: The bottom description.
    func set(bottomDescription: String?) {
        if let html = bottomDescription?.htmlString {
            let mutableString = NSMutableAttributedString(attributedString: html)
            let paragraphStyle = NSMutableParagraphStyle()
            let range = NSRange(location: 0, length: mutableString.length)
            
            paragraphStyle.alignment = .center
            mutableString.addAttribute(
                .font,
                value: UIFont.systemFont(ofSize: 13),
                range: range
            )
            mutableString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: range
            )
            
            bottomDescriptionLabel.set(text: mutableString)
        } else {
            bottomDescriptionLabel.label.text = bottomDescription
        }
        bottomDescriptionLabel.isHidden = bottomDescription == nil
    }
    
    /// Sets the dynamic content on the cell
    /// - Parameter content: The content to load and create buttons for
    func set(content: [PromotionContent]?) {
        guard let content else { return }
        
        content.forEach { promoContent in
            autoreleasepool {
                let vew = ANFButton(
                    withTitle: promoContent.title,
                    localizedId: promoContent.target,
                    localizationTitle: promoContent.title,
                    delegate: self
                )
                vew.set(dimension: .height, to: buttonHeight)
                contentStack.addArrangedSubview(vew)
            }
        }
    }
}

//  MARK: - Private extension to set dynamic constraints based on loaded content
private extension ExploreMarketplaceCell {
    
    /// Wrapper function to set the constraints
    func setPrimaryConstraints() {
        resetConstraints()
        
        setImageViewConstraints()
        setTopDescriptionConstraints()
        setTitleConsraints()
        setPromoConstraints()
        setBottomDescriptionConstraints()
        setContentConstraints()
        
        if let lastConstraint = lastView.pinTo(
            side: .bottom,
            of: contentView,
            with: -viewOffset*2
        ) { activeConstraints.append(lastConstraint) }
        
        invalidateIntrinsicContentSize()
        updateConstraints()
        layoutSubviews()
    }
    
    /// Removes all custom constraints
    func resetConstraints() {
        activeConstraints.forEach({ $0.remove() })
    }
    
    /// Sets the image view constraints to fit the provided image
    func setImageViewConstraints() {
        activeConstraints = primaryImageView.pinToSuperview(
            with: viewOffset.insetValue,
            except: .bottom
        )
        if let img = primaryImageView.image {
            activeConstraints.append(
                primaryImageView.set(
                    dimension: .height,
                    to: img.size.width >= 0
                        ? frame.width * (img.size.height / img.size.width)
                        : 0
                )
            )
        }
        lastView = primaryImageView
    }
    
    /// Sets the top description constraints to fit under
    /// the image
    func setTopDescriptionConstraints() {
        guard topDescriptionLabel.text?.isEmpty == false
        else { return }
        
        activeConstraints.append(
            contentsOf: topDescriptionLabel.stackUnder(
                view: lastView
                , insets: doubleTopInsets
            )
        )
        lastView = topDescriptionLabel
    }
    
    /// Sets the title constraints, if visible, to under the last view
    func setTitleConsraints() {
        guard titleLabel.text?.isEmpty == false
        else { return }
        
        activeConstraints.append(
            contentsOf: titleLabel.stackUnder(
                view: lastView
                , insets: topInsets
            )
        )
        lastView = titleLabel
    }
    
    /// Sets the promo label çonstraints to under the last view
    func setPromoConstraints() {
        guard promoMessageLabel.text?.isEmpty == false
        else { return }
        
        activeConstraints.append(
            contentsOf: promoMessageLabel.stackUnder(
                view: lastView
                , insets: topInsets
            )
        )
        lastView = promoMessageLabel
    }
    
    /// Sets the bottom description constraints under the last view
    func setBottomDescriptionConstraints() {
        guard bottomDescriptionLabel.label.text?.isEmpty == false
        else { return }
        
        activeConstraints.append(
            contentsOf: bottomDescriptionLabel.stackUnder(
                view: lastView,
                insets: doubleTopInsets
            )
        )
        lastView = bottomDescriptionLabel
    }
    
    /// Sets the content constraints for the stack view under the last view
    func setContentConstraints() {
        guard !contentStack.arrangedSubviews.isEmpty
        else { return }
        
        activeConstraints.append(
            contentsOf: contentStack.stackUnder(
                view: lastView
                , insets: doubleTopInsets
            )
        )
        lastView = contentStack
    }
    
}

//  MARK: - Button Delegate
extension ExploreMarketplaceCell: ANFButtonSelected {
    
    /// When the button on the stack is selected, the app should determine what action
    /// is associated by considering the current promotion and the content, based on the
    /// content identifier
    /// - Parameters:
    ///   - selected:   The button that was selected
    ///   - parent:     The parent of the view that was selected (not used)
    func button(selected: ANFButton, parent: UIView) {
        guard let promotion,
                let content = promotion.content,
              let current = content.first(
                where: { $0.target == selected.accessibilityIdentifier }
              ),
              let url = current.targetURL
        else { return }
        UIApplication.shared.open(url)
    }
}
