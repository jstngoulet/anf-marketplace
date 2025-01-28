//
//  ExploreMarketplaceCell.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import UIKit

class ExploreMarketplaceCell: UITableViewCell {
    
    private lazy var primaryImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var lastView: UIView = primaryImageView
    
    private lazy var topDescriptionLabel: MultilineLabel = {
       let lbl = MultilineLabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        return lbl
    }()
    
    private lazy var titleLabel: MultilineLabel = {
        let lbl = MultilineLabel()
        lbl.font = .systemFont(ofSize: 17, weight: .bold)
        return lbl
    }()
    
    private lazy var promoMessageLabel: MultilineLabel = {
        let lbl = MultilineLabel()
        lbl.font = .systemFont(ofSize: 11)
        return lbl
    }()
    
    private lazy var bottomDescriptionLabel: ANFClickableLabel = {
        ANFClickableLabel()
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = viewOffset
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        return stack
    }()
    
    private var activeConstraints: [NSLayoutConstraint] = []
    
    private var topInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: viewOffset,
            left: 0,
            bottom: viewOffset,
            right: 0
        )
    }
    
    var promotion: Promotion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        primaryImageView.image = nil
        promotion = nil
    }
    
    func addSubviews() {
        contentView.add([
            primaryImageView
            , topDescriptionLabel
            , titleLabel
            , promoMessageLabel
            , bottomDescriptionLabel
            , contentStack
        ])
    }
}

extension ExploreMarketplaceCell {
    
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

extension ExploreMarketplaceCell {
    
    func set(imagePath: String) {
        guard let url = URL(string: imagePath)
        else { return }
        
        primaryImageView.downloadImage(
            with: UIImage(named: "anf-20160527-app-m-shirts"),
            imageUrl: url,
            animationOptions: ImageAnimationOptions(
                duration: 0.5,
                options: [.transitionCrossDissolve, .beginFromCurrentState]
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
    
    func set(topDescroption: String?) {
        topDescriptionLabel.text = topDescroption
        topDescriptionLabel.isHidden = topDescroption == nil
    }
    
    func set(title: String) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
    }
    
    func set(promoMessage: String?) {
        promoMessageLabel.text = promoMessage
        promoMessageLabel.isHidden = promoMessage == nil
    }
    
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
    
    func set(content: [PromotionContent]?) {
        guard let content else { return }
        
        content.forEach { promoContent in
            autoreleasepool {
                let vew = ANFButton(
                    withTitle: promoContent.title,
                    localizedId: promoContent.id.uuidString,
                    localizationTitle: promoContent.title,
                    delegate: self
                )
                vew.set(dimension: .height, to: buttonHeight)
                contentStack.addArrangedSubview(vew)
            }
        }
    }
}

extension ExploreMarketplaceCell {
    
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
    
    func resetConstraints() {
        activeConstraints.forEach({ $0.remove() })
    }
    
    func setImageViewConstraints() {
        activeConstraints = primaryImageView.pinToSuperview(
            with: viewOffset.insetValue,
            except: .bottom
        )
        if let img = primaryImageView.image {
            activeConstraints.append(
                primaryImageView.set(
                    dimension: .height,
                    to: frame.width * (img.size.height / img.size.width)
                )
            )
        }
        lastView = primaryImageView
    }
    
    func setTopDescriptionConstraints() {
        guard topDescriptionLabel.text?.isEmpty == false
        else { return }
        
        var updatedInsets = topInsets
        updatedInsets.top += viewOffset*2
        
        activeConstraints.append(
            contentsOf: topDescriptionLabel.stackUnder(
                view: lastView
                , insets: updatedInsets
            )
        )
        lastView = topDescriptionLabel
    }
    
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
    
    func setBottomDescriptionConstraints() {
        guard bottomDescriptionLabel.label.text?.isEmpty == false
        else { return }
        
        var updatedInsets = topInsets
        updatedInsets.top += viewOffset*2
        
        activeConstraints.append(
            contentsOf: bottomDescriptionLabel.stackUnder(
                view: lastView,
                insets: updatedInsets
            )
        )
        lastView = bottomDescriptionLabel
    }
    
    func setContentConstraints() {
        guard !contentStack.arrangedSubviews.isEmpty
        else { return }
        
        var updatedInsets = topInsets
        updatedInsets.top += viewOffset*2
        
        activeConstraints.append(
            contentsOf: contentStack.stackUnder(
                view: lastView
                , insets: lastView == titleLabel
                    ? updatedInsets
                    : topInsets
            )
        )
        lastView = contentStack
    }
    
}

extension ExploreMarketplaceCell: ANFButtonSelected {
    
    func button(selected: ANFButton, parent: UIView) {
        guard let promotion,
                let content = promotion.content,
              let current = content.first(
                where: { $0.id.uuidString == selected.accessibilityIdentifier}
              ),
              let url = current.targetURL
        else { return }
        UIApplication.shared.open(url)
    }
}
