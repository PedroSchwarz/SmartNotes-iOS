//
//  FloatingActionButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

enum FloatingActionButtonType {
    case account
    case regular
}

struct FloatingActionButton: View {
    let type: FloatingActionButtonType
    let backgroundColor: Color
    let action: () -> Void
    let image: String
    let secondaryImage: String?
    let showSecondaryImage: Bool
    let size: CGFloat
    let innerPadding: Double
    
    init(
        type: FloatingActionButtonType = .regular,
        backgroundColor: Color = Color(.systemBackground),
        action: @escaping () -> Void,
        image: String,
        secondaryImage: String? = nil,
        showSecondaryImage: Bool = false,
        size: CGFloat = 20,
        innerPadding: Double = 20
    ) {
        self.type = type
        self.backgroundColor = backgroundColor
        self.action = action
        self.image = image
        self.secondaryImage = secondaryImage
        self.showSecondaryImage = showSecondaryImage
        self.size = size
        self.innerPadding = innerPadding
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) { action() }
        }) {
            Image(systemName: showSecondaryImage ? secondaryImage ?? image : image)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size, alignment: .center)
                .foregroundColor(.primary)
                .padding(innerPadding)
                .if(
                    type == .regular,
                    content: {
                        $0.background(backgroundColor)
                    }
                )
                .if(type == .account,
                    content: {
                    $0.background(AnimatedMeshGradient().mask(Circle().stroke(lineWidth: 10).blur(radius: 5)))
                }
                )
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}

#Preview {
    FloatingActionButton(action: { }, image: "person.crop.circle")
}
