# Swift Chat Demo

A small iOS app that shows [Swift Chat](https://github.com/unionst/swift-chat) in six situations. Open `SwiftChatDemo.xcodeproj`, pick a simulator or your phone, and run. Xcode fetches the package on first open.

| Screen | What it shows | Where to look |
|---|---|---|
| Conversation | Sending, delivery receipts, typing dots, a reply | `Demos/ConversationDemo.swift`, `Model/Conversation.swift` |
| Group chat | Avatars and sender names with three people in the thread | `Demos/GroupDemo.swift` |
| Long thread | Loading older messages at the top | `Demos/HistoryDemo.swift` |
| Attachments | Photos, a location, and a poll | `Demos/AttachmentsDemo.swift` |
| Your colors | Tinted outgoing bubbles and input bar | `Demos/TintedDemo.swift` |
| Empty state | A conversation before its first message | `Demos/EmptyDemo.swift` |

Every screen is the same transcript, `Demos/DemoTranscript.swift`, with a few modifiers on top. That file is the whole integration: one `Chat`, one `Message` per row, and `onChatSend`.

## Requirements

- iOS 18 or later
- Xcode 26.1 or later

The project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen). You do not need XcodeGen to run the app.
