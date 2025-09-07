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
  @State private var showingSharePlayInvite = false

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
          HStack(spacing: 12) {
            Button("Start SharePlay") {
              chatManager.startSharePlay()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Invite to SharePlay") {
              showingSharePlayInvite = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
          }
          .padding(.horizontal)
        }

        // Messages List
        ScrollViewReader { proxy in
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
              ForEach(chatManager.messages) { message in
                MessageBubble(message: message, currentUserName: chatManager.currentUserName)
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
      .sheet(isPresented: $showingSharePlayInvite) {
        SharePlayInviteView(chatManager: chatManager, isPresented: $showingSharePlayInvite)
      }
    }
  }

  private func sendMessage() {
    chatManager.sendMessage(messageText)
    messageText = ""
  }
}

// MARK: - SharePlay Invite View
struct SharePlayInviteView: View {
  let chatManager: ChatManager
  @Binding var isPresented: Bool
  @State private var invitationResult: String = ""
  @State private var showingShareSheet = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Text("Invite Friends to SharePlay Chat")
          .font(.title2)
          .fontWeight(.semibold)
        
        Text("Choose how to invite friends to your SharePlay chat session:")
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
        VStack(spacing: 16) {
          Button(action: {
            showingShareSheet = true
          }) {
            HStack {
              Image(systemName: "square.and.arrow.up")
              Text("Share via Messages/AirDrop")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
          }
          
          Button(action: {
            startSharePlayDirectly()
          }) {
            HStack {
              Image(systemName: "shareplay")
              Text("Start SharePlay Session")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
          }
        }
        .padding(.horizontal)
        
        if !invitationResult.isEmpty {
          Text(invitationResult)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
        }
        
        Spacer()
      }
      .padding()
      .navigationTitle("SharePlay Invite")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            isPresented = false
          }
        }
      }
      .sheet(isPresented: $showingShareSheet) {
        ActivityViewController(activityItems: [chatManager.createSharePlayItemProvider()])
      }
    }
  }
  
  private func startSharePlayDirectly() {
    Task {
      let activity = ChatGroupActivity()
      
      switch await activity.prepareForActivation() {
      case .activationPreferred:
        do {
          _ = try await activity.activate()
          invitationResult = "SharePlay session started successfully!"
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isPresented = false
          }
        } catch {
          invitationResult = "Failed to start SharePlay: \(error.localizedDescription)"
        }
      case .activationDisabled:
        invitationResult = "SharePlay not available. Please start a FaceTime call first or use Messages."
      case .cancelled:
        invitationResult = "SharePlay invitation was cancelled"
      @unknown default:
        break
      }
    }
  }
}

// MARK: - Activity View Controller
struct ActivityViewController: UIViewControllerRepresentable {
  let activityItems: [Any]
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let itemProvider = activityItems.first as! NSItemProvider
    let configuration = UIActivityItemsConfiguration(itemProviders: [itemProvider])
    
    let controller = UIActivityViewController(activityItemsConfiguration: configuration)
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    // No updates needed
  }
}

#Preview {
  ChatView()
}
