//
//  ChatManager.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import SwiftUI
import GroupActivities
import Combine

// MARK: - Chat Manager
@MainActor
class ChatManager: ObservableObject {
  @Published var messages: [ChatMessage] = []
  @Published var isSharePlayActive = false
  @Published var groupSession: GroupSession<ChatGroupActivity>?

  private var messenger: GroupSessionMessenger?
  private var cancellables = Set<AnyCancellable>()

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

    // Listen for incoming messages using async/await
    Task {
      for await (message, _) in messenger.messages(of: ChatMessage.self) {
        await MainActor.run {
          self.messages.append(message)
        }
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
          print("Failed to activate SharePlay: \(error)")
        }
      case .activationDisabled:
        print("SharePlay activation disabled")
      case .cancelled:
        print("SharePlay activation cancelled")
      @unknown default:
        print("Unknown SharePlay activation result")
      }
    }
  }

  func sendMessage(_ text: String) {
    guard !text.isEmpty else { return }

    let message = ChatMessage(
      text: text,
      senderName: "You", // In a real app, get from user profile
      timestamp: Date()
    )

    if let messenger = messenger {
      // Send to other SharePlay participants
      messenger.send(message) { error in
        if let error = error {
          print("Failed to send message: \(error)")
        }
      }
    }

    // Add to local messages
    messages.append(message)
  }

  func leaveSharePlay() {
    groupSession?.leave()
    isSharePlayActive = false
    groupSession = nil
    messenger = nil
  }
}
