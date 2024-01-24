//
//  AuthViewModel.swift
//  ChatGPTApp
//
//  Created by Sean Curry on 2/1/24.
//
import FirebaseAuth
import SwiftUI

final class AuthViewModel: ObservableObject {

@Published var user: User?

  func listenToAuthState() {
    Auth.auth().addStateDidChangeListener { [weak self] _, user in
    guard let self = self else { return
     }
     self.user = user
     }
     }

  func signInAnonymously() {
  Auth.auth().signInAnonymously { authResult, error in }
  }

  func signOut() { do
  {
  try Auth.auth().signOut()
  } catch let signOutError as NSError {
  print("Error signing out: %@", signOutError) }
  }
 }
