//
//  PrimaryButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import SwiftUI

struct PrimaryButton: View {
    @State private var counter: Int = 0
    @State private var origin: CGPoint = .zero
    
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    LoadingIndicator()
                } else {
                    Image(systemName: "sparkles")
                }
                Text(isLoading ? "Generating..." : "Generate Notes")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .animation(.none, value: isLoading)
        }
        .if(isDisabled == false) {
            $0.background(
                AnimatedMeshGradient()
                    .mask(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 16)
                            .blur(radius: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 3)
                            .blur(radius: 2)
                            .blendMode(.overlay)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 1)
                            .blur(radius: 1)
                            .blendMode(.overlay)
                    )
            )
        }
        .background(.black)
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.primary.opacity(0.5), lineWidth: 1)
        )
        .disabled(isLoading || isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .animation(.default, value: isDisabled)
        .onPressingChanged { point in
            if isLoading || isDisabled { return }
            if let point {
                origin = point
                counter += 1
            }
        }
        .modifier(RippleEffect(at: origin, trigger: counter))
    }
}

#Preview {
    PrimaryButton(isLoading: false, isDisabled: true) {
        
    }
    .padding(40)
}
