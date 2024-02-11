//
//  ChatGPTAppApp.swift
//  ChatGPTApp
//
//  Created by Sean Curry on 1/24/24.
//
//test the new branch

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}


@main
struct ChatGPTAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ChatView().environmentObject(AuthViewModel())
//            NavigationView {  ChatView().environmentObject(AuthViewModel())   }
        }
    }
}

