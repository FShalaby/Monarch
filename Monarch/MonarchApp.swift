//
//  MonarchApp.swift
//  Monarch
//
//  Created by Fouad on 2025-06-13.
//

import SwiftUI
import Firebase

@main
struct MonarchApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
