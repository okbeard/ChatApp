//
//  ChatView.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import SwiftUI

// MARK: - Chat View
struct ChatView: View {
  @StateObject private var chatManager = ChatManager()
  @State private var messageText = ""

  var body: some View {
    NavigationView {
      VStack {
        // SharePlay Status
        if chatManager.isSharePlayActive {
          HStack {
            Image(systemName: "shareplay")
              .foregroundColor(.blue)
            Text("SharePlay Active")
              .font(.caption)
              .foregroundColor(.blue)
            Spacer()
            Button("Leave") {
              chatManager.leaveSharePlay()
            }
            .font(.caption)
            .foregroundColor(.red)
          }
          .padding(.horizontal)
          .padding(.vertical, 8)
          .background(Color.blue.opacity(0.1))
        } else {
          Button("Start SharePlay Chat") {
            chatManager.startSharePlay()
          }
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
        }

        // Messages List
        ScrollViewReader { proxy in
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
              ForEach(chatManager.messages) { message in
                MessageBubble(message: message)
                  .id(message.id)
              }
            }
            .padding()
          }
          .onChange(of: chatManager.messages.count) { _ in
            if let lastMessage = chatManager.messages.last {
              withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
              }
            }
          }
        }

        // Message Input
        HStack {
          TextField("Type a message...", text: $messageText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onSubmit {
              sendMessage()
            }

          Button("Send") {
            sendMessage()
          }
          .disabled(messageText.isEmpty)
        }
        .padding()
      }
      .navigationTitle("SharePlay Chat")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  private func sendMessage() {
    chatManager.sendMessage(messageText)
    messageText = ""
  }
}

#Preview {
  ChatView()
}
