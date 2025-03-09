//
//  AnimatedMeshGradient.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 22/2/2025.
//

import SwiftUI

struct AnimatedMeshGradient: View {
    @State private var animationDefault: Bool = false
    @State private var animationWithDelay: Bool = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [animationWithDelay ? 0.5 : 1.0, 0.0], [1.0, 0.0],
                [0.0, 0.5], animationDefault ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
                [0.0, 1.0], [1.0, animationWithDelay ? 2.0 : 1.0], [1.0, 1.0]
            ],
            colors: [
                animationWithDelay ? .red : .mint, animationWithDelay ? .yellow : .cyan, .orange,
                animationDefault ? .blue : .red, animationDefault ? .cyan : .white, animationDefault ? .red : .purple,
                animationDefault ? .red : .cyan, animationDefault ? .mint : .blue, animationWithDelay ? .red : .blue
            ]
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animationDefault.toggle()
            }
            
            withAnimation(.easeInOut(duration: 1.5).delay(0.5).repeatForever(autoreverses: true)) {
                animationWithDelay.toggle()
            }
        }
    }
}

#Preview {
    AnimatedMeshGradient()
        .ignoresSafeArea()
}
