//
//  ChatMessage.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import Foundation

// MARK: - Message Model
struct ChatMessage: Codable, Identifiable {
  let id: UUID
  let text: String
  let senderName: String
  let timestamp: Date

  init(id: UUID = UUID(), text: String, senderName: String, timestamp: Date) {
    self.id = id
    self.text = text
    self.senderName = senderName
    self.timestamp = timestamp
  }
}
