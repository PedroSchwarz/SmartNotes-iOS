//
//  LoadingIndicator.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: isAnimating ? 1 : 0.7)
            .stroke(Color.white, lineWidth: 2)
            .animation(.linear(duration: 1).delay(0.5).repeatForever(autoreverses: true), value: isAnimating)
            .frame(width: 16, height: 16)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    LoadingIndicator()
}
