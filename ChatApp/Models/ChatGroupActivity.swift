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
  static let activityIdentifier = "com.yourapp.chat"

  var metadata: GroupActivityMetadata {
    var metadata = GroupActivityMetadata()
    metadata.title = "Chat Together"
    metadata.subtitle = "Share messages with friends"
    metadata.previewImage = UIImage(systemName: "message.fill")?.cgImage
    metadata.type = .generic
    return metadata
  }
}
