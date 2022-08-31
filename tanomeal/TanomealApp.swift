//
//  tanomealApp.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/08.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().languageCode = "ja_JP"
        return true
    }
}

@main
struct TanomealApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            Authenticate()
        }
    }
}
