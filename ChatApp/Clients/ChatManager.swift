//
//  ChatManager.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import SwiftUI
import GroupActivities
import Combine
import Foundation

// MARK: - SharePlay Message Types
enum SharePlayMessage: Codable {
  case chatMessage(ChatMessage)
  case messageHistory([ChatMessage])
  case requestHistory
}

// MARK: - Chat Manager
@MainActor
class ChatManager: ObservableObject {
  @Published var messages: [ChatMessage] = []
  @Published var isSharePlayActive = false
  @Published var groupSession: GroupSession<ChatGroupActivity>?

  private var messenger: GroupSessionMessenger?
  private var cancellables = Set<AnyCancellable>()
  let currentUserName = "User_\(UUID().uuidString.prefix(6))" // Unique identifier per participant

  init() {
    setupGroupSession()
  }

  private func setupGroupSession() {
    Task {
      for await session in ChatGroupActivity.sessions() {
        configureGroupSession(session)
      }
    }
  }

  private func configureGroupSession(_ session: GroupSession<ChatGroupActivity>) {
    self.groupSession = session
    self.isSharePlayActive = true

    let messenger = GroupSessionMessenger(session: session)
    self.messenger = messenger

    session.join()

    // Listen for SharePlay messages
    Task {
      for await (sharePlayMessage, _) in messenger.messages(of: SharePlayMessage.self) {
        await MainActor.run {
          self.handleSharePlayMessage(sharePlayMessage)
        }
      }
    }

    // Request message history when joining
    Task {
      try? await Task.sleep(nanoseconds: 500_000_000) // Wait 0.5s for session to stabilize
      await MainActor.run {
        self.requestMessageHistory()
      }
    }

    // Monitor session state changes
    Task {
      for await state in session.$state.values {
        await MainActor.run {
          switch state {
          case .invalidated:
            self.isSharePlayActive = false
            self.groupSession = nil
            self.messenger = nil
          case .joined:
            self.isSharePlayActive = true
          case .waiting:
            // Session is waiting for participants
            break
          @unknown default:
            break
          }
        }
      }
    }
  }

  func startSharePlay() {
    Task {
      let activity = ChatGroupActivity()

      switch await activity.prepareForActivation() {
      case .activationPreferred:
        do {
          _ = try await activity.activate()
        } catch {
          addSystemMessage("Failed to start SharePlay: \(error.localizedDescription)")
        }
      case .activationDisabled:
        addSystemMessage("SharePlay not available. Start a FaceTime call or Messages conversation first.")
      case .cancelled:
        addSystemMessage("SharePlay cancelled")
      @unknown default:
        break
      }
    }
  }

  func createSharePlayItemProvider() -> NSItemProvider {
    let activity = ChatGroupActivity()
    let itemProvider = NSItemProvider()
    itemProvider.registerGroupActivity(activity)
    return itemProvider
  }

  func sendMessage(_ text: String) {
    guard !text.isEmpty else { return }

    let message = ChatMessage(
      text: text,
      senderName: currentUserName,
      timestamp: Date()
    )

    // Add to local messages immediately
    messages.append(message)

    // Send to other SharePlay participants if in session
    if let messenger = messenger {
      messenger.send(SharePlayMessage.chatMessage(message)) { error in
        if let error = error {
          print("Failed to send message: \(error)")
        }
      }
    }
  }

  private func handleSharePlayMessage(_ sharePlayMessage: SharePlayMessage) {
    switch sharePlayMessage {
    case .chatMessage(let message):
      // Only add if not already in messages (avoid duplicates)
      if !messages.contains(where: { $0.id == message.id }) {
        messages.append(message)
        // Sort messages by timestamp to maintain order
        messages.sort { $0.timestamp < $1.timestamp }
      }
      
    case .messageHistory(let historyMessages):
      // Merge history with current messages, avoiding duplicates
      for message in historyMessages {
        if !messages.contains(where: { $0.id == message.id }) {
          messages.append(message)
        }
      }
      messages.sort { $0.timestamp < $1.timestamp }
      
    case .requestHistory:
      // Send our message history to the requesting participant
      if let messenger = messenger, !messages.isEmpty {
        messenger.send(SharePlayMessage.messageHistory(messages)) { error in
          if let error = error {
            print("Failed to send message history: \(error)")
          }
        }
      }
    }
  }

  private func requestMessageHistory() {
    guard let messenger = messenger else { return }
    
    messenger.send(SharePlayMessage.requestHistory) { error in
      if let error = error {
        print("Failed to request message history: \(error)")
      }
    }
  }

  private func addSystemMessage(_ text: String) {
    let systemMessage = ChatMessage(
      text: text,
      senderName: "System",
      timestamp: Date()
    )
    messages.append(systemMessage)
    
    // Also send system messages to SharePlay participants
    if let messenger = messenger {
      messenger.send(SharePlayMessage.chatMessage(systemMessage)) { error in
        if let error = error {
          print("Failed to send system message: \(error)")
        }
      }
    }
  }

  func leaveSharePlay() {
    groupSession?.leave()
    isSharePlayActive = false
    groupSession = nil
    messenger = nil
  }
}
