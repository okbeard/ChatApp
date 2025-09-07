//
//  ChatGroupActivity.swift
//  ChatApp
//
//  Created by 송지연 on 7/15/25.
//

import GroupActivities
import SwiftUI

// MARK: - Group Activity
struct ChatGroupActivity: GroupActivity {
  static let activityIdentifier = "com.okbeard.ChatAppExample.chat"

  var metadata: GroupActivityMetadata {
    var metadata = GroupActivityMetadata()
    metadata.title = "SharePlay Chat"
    metadata.subtitle = "Chat together in real-time"
    metadata.previewImage = UIImage(systemName: "message.badge.filled.fill")?.cgImage
    metadata.type = .generic
    metadata.supportsContinuationOnTV = false
    return metadata
  }
}
