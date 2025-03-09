import SwiftUI

struct SignUpView: View {
    @State private var viewModel: SignUpViewModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            // Title Section
            SignUpHeader(
                title: "Create an account",
                subtitle: "Begin your 30-day complimentary trial immediately.",
                animate: viewModel.animate
            )
            
            // Email Input
            AuthField(
                value: $viewModel.email,
                onChange: viewModel.validateEmail,
                label: "Email address",
                trailingImage: "envelope.fill",
                animate: viewModel.animate,
                error: viewModel.emailError,
                keyboardType: .emailAddress
            )
            
            // Password Input
            AuthField(
                type: viewModel.isPasswordVisible ? .regular : .password,
                value: $viewModel.password,
                label: "Password",
                trailingImage: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill",
                trailingAction: viewModel.togglePasswordVisibility,
                animate: viewModel.animate,
                error: viewModel.passwordError
            )
            
            // Forgot Password
            ForgotPassword(action: { }, animate: viewModel.animate)
            
            // Continue Button
            ActionButton(
                action: viewModel.validateAndSubmit,
                label: "Continue",
                trailingIcon: "chevron.right",
                animate: viewModel.animate
            )
            
            Divider()
                .opacity(viewModel.animate ? 1 : 0)
                .offset(y: viewModel.animate ? 0 : 20)
                .blur(radius: viewModel.animate ? 0 : 10)
                .animation(.easeOut(duration: 0.5).delay(0.7), value: viewModel.animate)
            
            // Google Sign Up Button
            SocialButton(
                action: {},
                label: "Sign up with Google",
                image: "g.circle.fill",
                animate: viewModel.animate
            )
            
            SocialButton(
                action: {},
                label: "Sign up with Apple",
                image: "apple.logo",
                animate: viewModel.animate
            )
        }
        .padding(20)
        .background(.white.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
        .onAppear { withAnimation { viewModel.animateView() } }
    }
}

#Preview {
    SignUpView()
        .preferredColorScheme(.dark)
        .background(Color.black)
}
