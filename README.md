# 💬 SharePlay Chat App

A real-time chat application built with SwiftUI that leverages Apple's SharePlay technology for synchronized messaging across FaceTime sessions.

## ✨ Features

### 🔄 SharePlay Integration
- **Real-time Message Synchronization**: Messages are instantly shared across all SharePlay participants
- **Message History Sync**: New participants automatically receive the full chat history when joining
- **Multiple Invitation Methods**: Start SharePlay directly or invite friends via Messages/AirDrop

### 💬 Chat Functionality
- **Unique User Identification**: Each participant gets a unique identifier (e.g., "User_ABC123")
- **Message Deduplication**: Prevents duplicate messages from appearing
- **Chronological Ordering**: Messages are automatically sorted by timestamp
- **Visual Message Differentiation**: 
  - Your messages appear on the right in blue
  - Other participants' messages appear on the left in gray
  - System messages appear centered in orange

### 🎯 User Experience
- **SharePlay Status Indicator**: Shows when SharePlay is active
- **Seamless Session Management**: Easy join/leave functionality
- **Cross-Platform Support**: Works on iPhone, iPad, and Mac

## 🛠 Technical Stack

- **Framework**: SwiftUI
- **SharePlay**: GroupActivities framework
- **Real-time Messaging**: GroupSessionMessenger
- **Platform**: iOS 15.4+, iPadOS 15.4+, macOS 13.0+
- **Language**: Swift 5.0

## 📁 Project Structure

```
ChatApp/
├── Models/
│   ├── ChatMessage.swift          # Message data model
│   └── ChatGroupActivity.swift    # SharePlay activity definition
├── Views/
│   ├── ChatView.swift            # Main chat interface
│   ├── MessageBubble.swift       # Individual message display
│   └── ContentView.swift         # App entry point
├── Clients/
│   └── ChatManager.swift         # Core SharePlay logic
└── ChatApp.entitlements          # SharePlay permissions
```

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0+
- iOS 15.4+ / iPadOS 15.4+ / macOS 13.0+
- Apple Developer Account (for SharePlay entitlements)
- Two or more physical devices for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ChatApp.git
   cd ChatApp
   ```

2. **Open in Xcode**
   ```bash
   open ChatApp.xcodeproj
   ```

3. **Configure Developer Settings**
   - Set your development team in project settings
   - Ensure SharePlay entitlements are properly configured
   - Build and run on physical devices (SharePlay doesn't work in simulators)

## 🧪 Testing SharePlay

### Method 1: Direct SharePlay Session
1. **Start FaceTime call** between two devices
2. **Open ChatApp** on both devices
3. **Tap "Start SharePlay"** on one device
4. **Accept SharePlay invitation** on the other device
5. **Start chatting** - messages will sync in real-time

### Method 2: Invite via Messages
1. **Open ChatApp** on device 1
2. **Tap "Invite to SharePlay"**
3. **Select "Share via Messages/AirDrop"**
4. **Choose "Messages"** and select contacts
5. **Send invitation** - recipients will get a SharePlay invite
6. **Join from invitation** on device 2
7. **Start chatting** with full message history sync

### Expected Behavior
- ✅ New participants see full chat history
- ✅ Messages appear instantly on all devices
- ✅ Each user has a unique identifier
- ✅ Messages maintain chronological order
- ✅ System messages notify of SharePlay events

## 🔧 Configuration

### SharePlay Entitlements
The app includes the required SharePlay entitlement in `ChatApp.entitlements`:
```xml
<key>com.apple.developer.group-session</key>
<true/>
```

### Bundle Identifier
Update the bundle identifier in project settings to match your developer account:
```
com.okbeard.ChatAppExample
```

## 📱 Supported Platforms

| Platform | Version | Status |
|----------|---------|---------|
| iOS      | 15.4+   | ✅ Fully Supported |
| iPadOS   | 15.4+   | ✅ Fully Supported |
| macOS    | 13.0+   | ✅ Fully Supported |
| visionOS | 2.5+    | ✅ Compatible |

## 🐛 Troubleshooting

### SharePlay Not Working
- Ensure you're testing on physical devices (not simulators)
- Verify SharePlay entitlements are configured
- Check that FaceTime is working between devices
- Confirm both devices have the app installed

### Messages Not Syncing
- Check network connectivity on both devices
- Verify SharePlay session is active (blue indicator should show)
- Try leaving and rejoining the SharePlay session

### Build Issues
- Ensure Xcode 16.0+ is being used
- Verify development team is set correctly
- Check that all dependencies are resolved

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes with gitmoji (`git commit -m '✨ Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple's GroupActivities framework documentation
- SwiftUI community resources
- SharePlay development guidelines

## 📞 Support

If you encounter any issues or have questions:
1. Check the troubleshooting section above
2. Search existing issues in the repository
3. Create a new issue with detailed information about the problem

---

**Built with ❤️ using SwiftUI and SharePlay**
