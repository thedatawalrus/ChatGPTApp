//
//  ChatViewModel.swift
//  ChatGPTApp
//
//  Created by Sean Curry on 1/24/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseAuth
import Combine
import FirebaseCore


extension ChatView {
    class ViewModel: ObservableObject {
        
//        @Published var favourite = Favourite.empty
        @Published var messages: [Message] = [Message(id: UUID(), role: .system, content: "Your job is to create an itinerary for a group of people using inputs from individuals in the group. An activity must be scheduled for the entire amount of time required that is given by the individual. An activity cannot be shortened. All activities marked as type: group must be done by everyone in the group. An activity must begin at the start time provided. The start time cannot be altered. You must ensure that there are no conflicts in the itinerary. If there are conflicts you must pick one based on priority. Here is the logic to pick an activity if a conflict exists: 1. If an activity is marked 'high priority' and the other is not, then the 'high priority' item should be picked. 2. If more than one item is marked 'high priority' then the activity that was submitted first that was marked 'high priority' should be picked. 3. If no activies are marked 'high priority' then the activity that was submitted first should be picked.", createAt: Date())]
        
//        @Published private var user: User?
        private var db = Firestore.firestore()
        
//        private var cancellables = Set<AnyCancellable>()
//
//        init() {
//          registerAuthStateHandler()
//
//          $user
//            .compactMap { $0 }
//            .sink { user in
//              self.messages.id = user.uid
//            }
//            .store(in: &cancellables)
//        }
//
//        private var authStateHandler: AuthStateDidChangeListenerHandle?
//
//        func registerAuthStateHandler() {
//          if authStateHandler == nil {
//            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//              self.user = user
////              self.fetchFavourite()
////              self.subscribeToFavourite()
//            }
//          }
//        }

        

        
        @Published var currentInput: String = ""
        
//        private var db = Firestore.firestore()
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            do {
              let _ = try db.collection("message").addDocument(from: newMessage)
            }
            catch {
              print(error)
            }
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run {
                    messages.append(receivedMessage)
                }
                
            }
        }
    }
}

struct Message: Codable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
    
}

//@objc(ViewController) // match the ObjC symbol name inside Storyboard
//class ViewController: UIViewController {
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//
//    recordScreenView()
//
//    // [START custom_event_swift]
//    Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//      AnalyticsParameterItemID: "id-\(title!)",
//      AnalyticsParameterItemName: title!,
//      AnalyticsParameterContentType: "cont",
//    ])
//    // [END custom_event_swift]
//  }
//
//  func recordScreenView() {
//    // These strings must be <= 36 characters long in order for setScreenName:screenClass: to succeed.
//    guard let screenName = title else {
//      return
//    }
//    let screenClass = classForCoder.description()
//
//    // [START set_current_screen]
//    Analytics.logEvent(AnalyticsEventScreenView,
//                       parameters: [AnalyticsParameterScreenName: screenName,
//                                    AnalyticsParameterScreenClass: screenClass])
//    // [END set_current_screen]
//  }
//}
