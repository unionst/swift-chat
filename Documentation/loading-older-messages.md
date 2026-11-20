# Loading older messages

[Swift Chat](../README.md) › Loading older messages

```swift
Chat(conversation.messages) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
}
.chatLoadsOlderMessages {
    await conversation.loadOlderPage()
}
```

Once the thread is tall enough to scroll, the transcript keeps its own spinner above the oldest message; scrolling up finds it already there, reaching it asks for the next page, and the reader’s position holds when the page lands. A thread that fits on screen shows no spinner and asks once on open, so a short cached window still fills and a short thread with nothing older never spins.

The spinner stays until the loader returns `false`, so a thread whose first page already holds everything spins until the reader reaches the top and the loader answers. When your server says whether a page has anything behind it, pass that along and the spinner is drawn only when there is a page to fetch:

```swift
.chatLoadsOlderMessages { await conversation.loadOlderPage() }
.chatHasOlderMessages(conversation.hasOlderMessages)
```

`false` draws nothing above the oldest row and asks the loader for nothing, `true` keeps the spinner there (and clears an earlier `false`, say after a gap in the cache), and `nil` means not known yet, which behaves exactly as it does without the modifier.
