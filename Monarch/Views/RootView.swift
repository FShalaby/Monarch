//
//  RootView.swift
//  Monarch
//
//  Created by Fouad on 2025-06-16.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @StateObject var authViewModel = UserAuthViewModel()

    var body: some View {
        if authViewModel.isLoggedIn, let user = authViewModel.user {
            ContentView(
                authViewModel: authViewModel,
                viewModel: ExpenseViewModel(userId: user.uid)
            )
        } else {
            LoginView(viewModel: authViewModel)
        }
    }
}
