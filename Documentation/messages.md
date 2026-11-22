# Messages

[Swift Chat](../README.md) › Messages

Every `Message` takes text, a role, and a timestamp. Modifiers add the rest:

```swift
Message(message.text, role: message.role, timestamp: message.sentAt)
    .messageStatus(.read)
    .messageMedia(.image(url: photoURL, width: 1200, height: 800, blurhash: "LEHV6nWB2yk8pyo0adR*.7kCMdnj"))
    .messageHeader { Text("Alex").font(.caption) }
    .messageFooter { Text("Edited").font(.caption2) }
    .messageAvatar { AvatarView(user: message.sender) }
    .messageStyle(.plain)
    .contextMenu {
        Button("Copy") { copy(message) }
    }
```

| Modifier | What it does |
|---|---|
| `messageStatus(_:)` | Shows sending, sent, delivered, read, or failed under the bubble |
| `messageMedia(_:)` | Attaches a photo, several photos as one collage, or a file |
| `messageReactions(_:)` | Draws tapbacks on the bubble |
| `messageReply(to:quote:)` | Draws the message as a reply to another. See [Replies](#replies). |
| `messageAttachment { }` | Renders a custom SwiftUI view as the attachment |
| `messageHeader { }` | A view above the bubble, such as a sender name |
| `messageFooter { }` | A view below the bubble |
| `messageAvatar { }` | A custom avatar for incoming messages |
| `messageStyle(_:)` | `.default` for bubbles, `.plain` for bare text, `.suggestion` for a dashed outline that sends its text on a tap. See [Agent chats](agents.md#offer-the-next-message). |
| `font(_:)` | Overrides the bubble text font |
| `contextMenu { }` | A long-press menu for that message |
| `contentVersion(_:)` | Forces a re-render when content changes but the id does not |

## Attachments

```swift
MessageMedia.image(url: URL, width: Int? = nil, height: Int? = nil, blurhash: String? = nil)
MessageMedia.file(url: URL, name: String, size: Int64? = nil, mimeType: String? = nil)
```

**Photos.** Hand `messageMedia(_:)` an array of images and they are drawn as one collage. Pass width and height to get correctly sized placeholders with no layout shift, and a BlurHash to show a blurred preview while the image loads. `image(url:)` takes `https:`, `file:`, and `data:` URLs. A `data:` URL is decoded in place, so an inline base64 photo renders and opens full screen like any other; network images are cached on disk, local files are read directly.

**Files.** A file is drawn as a bubble the way Messages draws one: its Quick Look thumbnail, its name, and its kind and size. Tapping it opens the file in Quick Look, downloaded first when the URL is remote; add `onChatFileTap { id, file in }` to handle the tap yourself, for example when the file needs your own authorization or download.

**Everything else.** `MessageMedia` also declares `video`, `audio`, `location`, and `poll`. The transcript does not draw those yet; a picked video shows in the input strip and reaches `onChatSend`, and the host draws it in the thread with `messageAttachment { }`.

## Tapbacks and the long-press menu

```swift
Chat(conversation.messages) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
        .messageReactions(message.reactions)
}
.chatMessageContextMenu { (id: ChatMessage.ID) in
    ChatContextMenuItem.tapbacks(conversation.reactions(on: id)) { emoji in
        conversation.toggleReaction(emoji, on: id)
    }
    Divider()
    ChatContextMenuItem("Copy", systemImage: "doc.on.doc") {
        UIPasteboard.general.string = conversation.text(of: id)
    }
    if conversation.isMine(id) {
        ChatContextMenuItem("Delete", systemImage: "trash", destructive: true) {
            conversation.delete(id)
        }
    }
}
```

The menu is a result builder: write items one after another, put `Divider()` between groups, and use `if`, `else`, and `for` the way you would in a view. A closure that returns an array of items still works.

## Replies

```swift
Chat(conversation.messages) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
        .messageReply(to: message.replyToID)
}
.onChatSend { text, media in
    await conversation.send(text, media: media)
}
.onChatReply { parentID, text, media in
    await conversation.send(text, media: media, replyTo: parentID as? String)
}
```

`messageReply(to:)` draws a message as a reply: the message it answers sits above it as a small outlined quote, joined by a line, and the original shows “1 Reply” under its bubble. Pass `quote:` too for an original that is not loaded yet.

`onChatReply` turns on the rest. Swipe a message to the right and its thread opens: the original and its replies over the blurred conversation, the field reading “Reply”, the keyboard up. Tapping “1 Reply” opens it without the keyboard, and the close button in the header or a tap on the blur goes back. A send while a thread is open goes to `onChatReply` with the id of the message that started the thread, so a reply to a reply stays in the same thread. Without the handler there is no swipe and no thread.
