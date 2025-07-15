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

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(message.senderName)
          .font(.caption)
          .fontWeight(.semibold)
          .foregroundColor(.secondary)

        Spacer()

        Text(message.timestamp, style: .time)
          .font(.caption2)
          .foregroundColor(.secondary)
      }

      Text(message.text)
        .padding(12)
        .background(
          message.senderName == "You" ? Color.blue : Color.gray.opacity(0.2)
        )
        .foregroundColor(
          message.senderName == "You" ? .white : .primary
        )
        .cornerRadius(16)
    }
    .frame(maxWidth: .infinity, alignment: message.senderName == "You" ? .trailing : .leading)
  }
}

#Preview {
  MessageBubble(
    message: .init(
      text: "Hello, World!",
      senderName: "You",
      timestamp: Date.now
    )
  )
}
