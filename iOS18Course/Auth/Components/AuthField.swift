//
//  AuthField.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

enum AuthFieldType {
    case regular
    case password
}

struct AuthField: View {
    let type: AuthFieldType
    let value: Binding<String>
    let onChange: (() -> Void)?
    let label: String
    let trailingImage: String
    let trailingAction: (() -> Void)?
    let animate: Bool
    let error: String?
    
    let autocapitalization: UITextAutocapitalizationType
    let keyboardType: UIKeyboardType
    
    init(
        type: AuthFieldType = .regular,
        value: Binding<String>,
        onChange: (() -> Void)? = nil,
        label: String,
        trailingImage: String,
        trailingAction: (() -> Void)? = nil,
        animate: Bool,
        error: String? = nil,
        autocapitalization: UITextAutocapitalizationType = .none,
        keyboardType: UIKeyboardType = .default
    ) {
        self.type = type
        self.value = value
        self.onChange = onChange
        self.label = label
        self.trailingImage = trailingImage
        self.trailingAction = trailingAction
        self.animate = animate
        self.error = error
        self.autocapitalization = autocapitalization
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                switch type {
                case .regular:
                    TextField(label, text: value)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                        .autocapitalization(autocapitalization)
                        .keyboardType(keyboardType)
                        .onChange(of: value.wrappedValue) { onChange?() }
                case .password:
                    SecureField(label, text: value)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Button(action: trailingAction ?? {}) {
                    Image(systemName: trailingImage)
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.1))
                                .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.red.opacity(1), .green.opacity(1), .blue.opacity(1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.2))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
            .cornerRadius(10)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 20)
            .blur(radius: animate ? 0 : 10)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: animate)
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }
        }
    }
}

#Preview {
    AuthField(
        value: .constant(""),
        label: "Email Address",
        trailingImage: "envelope.fill",
        animate: true
    )
}
