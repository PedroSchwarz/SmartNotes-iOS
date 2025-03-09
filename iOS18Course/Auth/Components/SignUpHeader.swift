//
//  SignUpHeader.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct SignUpHeader: View {
    let title: String
    let subtitle: String
    let animate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .primary.opacity(0.5), radius: 60, y: 30)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .blur(radius: animate ? 0 : 10)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)
            
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 20)
                .blur(radius: animate ? 0 : 10)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: animate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SignUpHeader(title: "Title", subtitle: "Subtitle", animate: true)
}
