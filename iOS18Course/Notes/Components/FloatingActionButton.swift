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
    let action: () -> Void
    let image: String
    let secondaryImage: String?
    let showSecondaryImage: Bool
    let verticalAlignment: VerticalAlignment
    let horizontalAlignment: HorizontalAlignment
    
    init(type: FloatingActionButtonType = .regular, action: @escaping () -> Void, image: String, secondaryImage: String? = nil, showSecondaryImage: Bool = false, verticalAlignment: VerticalAlignment, horizontalAlignment: HorizontalAlignment) {
        self.type = type
        self.action = action
        self.image = image
        self.secondaryImage = secondaryImage
        self.showSecondaryImage = showSecondaryImage
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
    }
    
    var body: some View {
        VStack {
            if verticalAlignment == .bottom {
                Spacer()
            }
            
            HStack {
                if horizontalAlignment == .trailing {
                    Spacer()
                }
                
                Button(action: {
                    withAnimation(.spring()) { action() }
                }) {
                    Image(systemName: showSecondaryImage ? secondaryImage ?? image : image)
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                        .padding()
                        .if(
                            type == .regular,
                            content: {
                                $0.background(Color(.systemBackground))
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
                
                if horizontalAlignment == .leading {
                    Spacer()
                }
            }
            
            if verticalAlignment == .top {
                Spacer()
            }
        }
    }
}

#Preview {
    FloatingActionButton(action: { }, image: "person.crop.circle", verticalAlignment: .top, horizontalAlignment: .trailing)
}
