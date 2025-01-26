//
//  BorderedButtonStyle.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/25/25.
//

import SwiftUI

struct BorderedButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .border(.black, width: 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .font(.system(size: 16, weight: .bold))
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
}

#Preview {
    Button("Button Style Preview") {}
        .buttonStyle(BorderedButtonStyle())
}
