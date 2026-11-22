# Assistant style

[Swift Chat](../README.md) › Assistant style

```swift
Chat(thread.messages, typingUsers: thread.thinking ? [assistant] : []) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
}
.chatStyle(.assistant)
.chatTypingStatus(thread.status)
.chatInputPlaceholder("Ask anything")
.onChatSend { text, _ in
    await thread.send(text)
}
```

For a thread with an assistant rather than a person. A sent message rises to the top of the screen instead of settling at the bottom, and the room under it is held open, so the reply streams in beneath it while the question stays put, the way Siri and ChatGPT answer. The transcript does not chase a reply that runs past the bottom of the screen; the reader scrolls to it, and the scroll-to-bottom button appears when something lands below the fold.

**Replies** are drawn as bare text across the full width, with no bubble, tail, or avatar column, and their words fade in one after another as they arrive, the way Siri’s answers do. Reply text is Markdown: headings, bullet and numbered lists, bold and italic, links, block quotes, code blocks, and rules all render as blocks, at 19 points by default; set `.font(_:)` on the `Message` to change it. A photo in a reply runs the full width of the thread and opens full screen on a tap; a `messageAttachment { }` view is drawn bare at full width, so a card you design is the card the reader sees. Long-press on a reply opens the same menu bubbles get.

**Your own messages** keep their bubbles, in gray with dark text rather than the accent color; `chatBubbleStyle(_:)` still recolors them. The message field is taller (`chatInputBarHeight(_:)`) and its send button is `.primary` (`chatInputControlTint(_:)`). A message that sets its own `messageStyle(_:)` keeps that style.

**While the assistant works**, show its typing indicator: in the assistant style it is a small ring spinner. `chatTypingStatus(_:)` puts a line beside it saying what is happening, such as “Searching”, and a new status rolls the old line up and out. Pass `nil` for the spinner alone.

**Stream a reply** by appending one message for it and rewriting that message’s text as tokens arrive. The row grows in place, each new word fades in, and nothing above moves. There is no timestamp separator in the assistant style.

The style is the layout. What an agent does inside it, the status line through its tool calls, results as cards, suggestions to tap, and turn-taking, is in [Agent chats](agents.md).
