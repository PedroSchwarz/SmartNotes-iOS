//
//  ForgotPassword.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

struct ForgotPassword: View {
    let action: () -> Void
    let animate: Bool
    
    var body: some View {
        Button(action: action) {
            Text("Forgot password")
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 20)
        .blur(radius: animate ? 0 : 10)
        .animation(.easeOut(duration: 0.5).delay(0.5), value: animate)
    }
}

#Preview {
    ForgotPassword(action: {}, animate: true)
}
