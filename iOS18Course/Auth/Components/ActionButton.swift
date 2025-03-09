//
//  SignUpButton.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct ActionButton: View {
    let action: () -> Void
    let label: String
    let leadingIcon: String?
    let trailingIcon: String?
    let animate: Bool
    
    init(
        action: @escaping () -> Void,
        label: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        animate: Bool
    ) {
        self.action = action
        self.label = label
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.animate = animate
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let leadingIcon = leadingIcon {
                    Image(systemName: leadingIcon)
                }
                
                Text(label)
                    .font(.system(size: 17))
                
                if let trailingIcon = trailingIcon {
                    Image(systemName: trailingIcon)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 20)
        .blur(radius: animate ? 0 : 10)
        .animation(.easeOut(duration: 0.5).delay(0.6), value: animate)
    }
}

#Preview {
    ActionButton(action: {}, label: "Continue", animate: true)
}
