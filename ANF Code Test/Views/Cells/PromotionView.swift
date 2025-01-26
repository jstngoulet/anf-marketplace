//
//  PromotionView.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import SwiftUI
import Combine

struct PromotionView: View {
    
    @State var promotiom: Promotion = Promotion(
        title: "",
        backgroundImagePath: "",
        content: nil,
        promoMessage: nil,
        topDescription: nil,
        bottomDescription: nil
    )
    @State private var loadedImage: Image = Image(uiImage: UIImage())
    var attributedDescription: NSAttributedString?
    
    var body: some View {
        
        VStack {
            
            ANFImageView(
                image: loadedImage,
                remotePath: promotiom.backgroundImagePath,
                loadCompletion: { img in
                    self.loadedImage = img
                }
            )
            
            if let topDescription = promotiom.topDescription {
                Text(topDescription)
                    .font(.system(size: 13))
                    .padding(.top, 8)
            }
            
            Text(promotiom.title)
                .font(.system(size: 16, weight: .bold))
                .padding(.top, 1)
            
            if let promoMessage = promotiom.promoMessage {
                Text(promoMessage)
                    .font(.system(size: 11))
                    .padding(.top, 1)
            }
            
            if let attributedDescription {
                    AttributedText(attributedDescription, textAlignment: .center)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
            }
            
            if let content = promotiom.content {
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
    
    mutating func set(htmlDescription: NSAttributedString?) {
        self.attributedDescription = htmlDescription
    }
}

#Preview {
    PromotionView(
        promotiom: Promotion(
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
}

#Preview("List") {
    List {
        PromotionView(
            promotiom: Promotion(
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
        PromotionView(
            promotiom: Promotion(
                title: "TEST",
                backgroundImagePath: "https://placecats.com/500/300",
                content: [
                    PromotionContent(target: "target", title: "TItle 1", elementType: nil)
                ],
                promoMessage: "Promo Message",
                topDescription: "Top Description",
                bottomDescription: "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>"
            )
        )
    }
}
