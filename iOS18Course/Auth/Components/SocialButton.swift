//
//  SocialButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct SocialButton: View {
    let action: () -> Void
    let label: String
    let image: String
    let animate: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.system(size: 17))
                Spacer()
                Image(systemName: image)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
            .cornerRadius(10)
        }
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 20)
        .blur(radius: animate ? 0 : 10)
        .animation(.easeOut(duration: 0.5).delay(0.8), value: animate)
    }
}

#Preview {
    SocialButton(
        action: { },
        label: "Sign up with Goggle",
        image: "g.circle.fill",
        animate: true
    )
}
