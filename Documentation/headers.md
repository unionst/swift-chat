# Headers

[Swift Chat](../README.md) › Headers

`chatHeader { }` pins any SwiftUI view above the transcript:

```swift
Chat(conversation.messages) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
}
.chatHeader {
    HStack {
        AvatarView(user: alex)
        VStack(alignment: .leading) {
            Text("Alex").font(.headline)
            Text("Online").font(.caption).foregroundStyle(.green)
        }
    }
}
```

## The built-in header

`ChatHeader` is the header Messages draws: a photo over a name. With a visible navigation bar it sits level with the back button.

```swift
.chatHeader {
    ChatHeader(title: "Alex", avatarURL: alex.photoURL) {
        showProfile = true
    }
}
```

A `subtitle` puts a second line under the name inside the same glass: where someone is, when they were last active, what an assistant is working on. Pass `nil` to take it away. The glass grows and shrinks around it while the header keeps its height, so the transcript never moves.

```swift
.chatHeader {
    ChatHeader(title: "Assistant", subtitle: assistant.currentThought, avatarURL: assistant.photoURL)
}
```

A group wears `ChatGroupAvatar`, which clusters up to seven faces the way Messages does:

```swift
.chatHeader {
    ChatHeader(title: "Team Chat") {
        ChatGroupAvatar(roles: members, size: 60) { role in
            ProfilePhoto(for: role)
        }
    }
}
```
