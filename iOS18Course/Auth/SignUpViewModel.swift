//
//  SignUpViewModel.swift
//  iOS18Course
//
//  Created by Pedro Schwarz Rodrigues on 23/2/2025.
//

import SwiftUI

@Observable
final class SignUpViewModel {
    var email: String = ""
    var password: String = ""
    private(set) var isPasswordVisible: Bool = false
    private(set) var emailError: String? = nil
    private(set) var passwordError: String? = nil
    private(set) var animate: Bool = false
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func animateView() {
        animate = true
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword() {
        if password.count < 8 {
            passwordError = "Password must be at least 8 characters long"
        } else {
            passwordError = nil
        }
    }
    
    func validateAndSubmit() {
        validateEmail()
        validatePassword()
        
        if emailError == nil && passwordError == nil {
            // Perform sign up action here
            print("Sign up successful")
        }
    }
}
