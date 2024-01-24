//
//  ContentView.swift
//  ChatGPTApp
//
//  Created by Sean Curry on 1/24/24.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAuth


struct ContentView: View {

@EnvironmentObject private var authModel: AuthViewModel
var body: some View {
VStack {
Text("You're logged in with ID: \(Auth.auth().currentUser?.uid ?? "")").onAppear(perform: authModel.listenToAuthState)
}.toolbar {
ToolbarItemGroup(placement: .bottomBar) {
Button(action: { authModel.signInAnonymously()
}) {
HStack {
Image(systemName: "person.circle") .font(.title)
Text("Sign in anonymously") .fontWeight(.semibold) .font(.callout)
}
}
}
ToolbarItemGroup(placement: .cancellationAction) {
Button(action: { authModel.signOut()
}) {
HStack {
Image(systemName: "rectangle.portrait.and.arrow.right").font(.title)
Text("Sign Out").fontWeight(.medium)
}
}
}
}
}
}

//struct ContentView_Previews: PreviewProvider { static var previews: some View {
//ContentView()
//}
//}


struct ChatView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    messageView(message: message)
                }
            }
            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                Button{
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }
            }
        }
        .padding()
        .analyticsScreen(name: "\(ChatView.self)")
        .onAppear(perform: authModel.signInAnonymously)
    }
    
    
    func messageView(message:Message) -> some View {
        HStack {
            if message.role == .user { Spacer()}
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
            if message.role == .assistant { Spacer()}
        }
    }
}

#Preview {
    ChatView()
}
