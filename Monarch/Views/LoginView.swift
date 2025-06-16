import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: UserAuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true

    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text(isLoginMode ? "Welcome Back" : "Create Account")
                .font(.largeTitle.bold())
                .foregroundColor(.primary)

            // Email & Password Input
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)

                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)

            // Error Message if exists
            if let error = viewModel.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Login/Register Button
            Button {
                if isLoginMode {
                    viewModel.login(email: email, password: password) { success in
                        // Handle post-login logic here (e.g. navigate)
                    }
                } else {
                    viewModel.register(email: email, password: password) { success in
                        // Handle post-register logic here
                    }
                }
            } label: {
                Text(isLoginMode ? "Login" : "Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            

            .padding(.horizontal)

            // Mode Toggle Button
            Button {
                withAnimation {
                    isLoginMode.toggle()
                    viewModel.errorMessage = nil
                }
            } label: {
                Text(isLoginMode ? "Don't have an account? Register" : "Already registered? Login")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
            .tint(.black)
            

            Spacer()
        }
        .padding(.top, 60)
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    LoginView(viewModel: UserAuthViewModel())
}
