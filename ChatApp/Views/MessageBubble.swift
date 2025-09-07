//
//  MessageBubble.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import SwiftUI

// MARK: - Message Bubble
struct MessageBubble: View {
  let message: ChatMessage
  let currentUserName: String
  
  private var isCurrentUser: Bool {
    message.senderName == currentUserName
  }
  
  private var isSystemMessage: Bool {
    message.senderName == "System"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(isCurrentUser ? "You" : message.senderName)
          .font(.caption)
          .fontWeight(.semibold)
          .foregroundColor(isSystemMessage ? .orange : .secondary)

        Spacer()

        Text(message.timestamp, style: .time)
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Text(message.text)
        .padding(12)
        .background(
          isCurrentUser ? Color.blue : 
          isSystemMessage ? Color.orange.opacity(0.2) : 
          Color.gray.opacity(0.2)
        )
        .foregroundColor(
          isCurrentUser ? .white :
          isSystemMessage ? .orange :
          .primary
        )
        .cornerRadius(16)
    }
    .frame(
      maxWidth: .infinity, 
      alignment: isCurrentUser ? .trailing : 
                isSystemMessage ? .center : .leading
    )
  }
}

#Preview {
  VStack {
    MessageBubble(
      message: .init(
        text: "Hello, World!",
        senderName: "User_ABC123",
        timestamp: Date.now
      ),
      currentUserName: "User_ABC123"
    )
    
    MessageBubble(
      message: .init(
        text: "How are you doing?",
        senderName: "User_DEF456", 
        timestamp: Date.now
      ),
      currentUserName: "User_ABC123"
    )
    
    MessageBubble(
      message: .init(
        text: "SharePlay session started",
        senderName: "System",
        timestamp: Date.now
      ),
      currentUserName: "User_ABC123"
    )
  }
  .padding()
}
