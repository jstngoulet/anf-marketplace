//
//  PromotionView.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import SwiftUI
import Combine

class PromotionViewModel: ObservableObject {
    
    @Published var promotion: Promotion
    @Published var attributedDescription: NSAttributedString?
    @Published var loadedImage: Image
    
    init(
        promotion: Promotion,
        loadedImage: Image = Image(uiImage: UIImage())
    ) {
        self.promotion = promotion
        self.loadedImage = loadedImage
        self.attributedDescription = promotion.bottomDescription?.htmlString
    }
    
}

struct PromotionView: View {
    
    @ObservedObject var promotionModel: PromotionViewModel
    
    var body: some View {
        
        VStack {
            ANFImageView(
                image: promotionModel.loadedImage,
                remotePath: promotionModel.promotion.backgroundImagePath
            )
            
            if let topDescription = promotionModel.promotion.topDescription {
                Text(topDescription)
                    .font(.system(size: 13))
                    .padding(.top, 8)
            }
            
            Text(promotionModel.promotion.title)
                .font(.system(size: 16, weight: .bold))
                .padding(.top, 1)
            
            if let promoMessage = promotionModel.promotion.promoMessage {
                Text(promoMessage)
                    .font(.system(size: 11))
                    .padding(.top, 1)
            }
            
            if let attributedDescription = promotionModel.attributedDescription {
                    AttributedText(attributedDescription, textAlignment: .center)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
            }
            
            if let content = promotionModel.promotion.content {
                VStack {
                    ForEach(content) { item in
                        Button(item.title) {
                            if let url = item.targetURL
                                , UIApplication.shared.canOpenURL(url){
                                UIApplication.shared.open(url, options: [:])
                            } 
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .padding(.top, 8)
                    }
                }
            }
        }
        .padding(8)
    }
}

#Preview {
    PromotionView(
        promotionModel: PromotionViewModel(
            promotion: Promotion(
                title: "Tops starting at $12",
                backgroundImagePath: "https://placecats.com/300/200",
                content: [
                    PromotionContent(target: "target", title: "Shop Men", elementType: nil),
                    PromotionContent(target: "target", title: "Shop Women", elementType: nil)
                ],
                promoMessage: "Use Code: 12345",
                topDescription: "A & F Essentials",
                bottomDescription: "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>"
            )
        )
    )
}

#Preview("List") {
    List {
        PromotionView(
            promotionModel: PromotionViewModel(
                promotion: Promotion(
                    title: "Tops starting at $12",
                    backgroundImagePath: "https://placecats.com/300/200",
                    content: [
                        PromotionContent(target: "target", title: "Shop Men", elementType: nil),
                        PromotionContent(target: "target", title: "Shop Women", elementType: nil)
                    ],
                    promoMessage: "Use Code: 12345",
                    topDescription: "A & F Essentials",
                    bottomDescription: "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>"
                )
            )
        )
        PromotionView(
            promotionModel: PromotionViewModel(
                promotion: Promotion(
                    title: "Tops starting at $12",
                    backgroundImagePath: "https://placecats.com/300/200",
                    content: [
                        PromotionContent(target: "target", title: "Shop Men", elementType: nil),
                        PromotionContent(target: "target", title: "Shop Women", elementType: nil)
                    ],
                    promoMessage: "Use Code: 12345",
                    topDescription: "A & F Essentials",
                    bottomDescription: "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>"
                )
            )
        )
    }
}
