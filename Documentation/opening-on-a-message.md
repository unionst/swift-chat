# Opening on a message

[Swift Chat](../README.md) › Opening on a message

```swift
Chat(conversation.messages) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
}
.chatInitialScrollTarget(id: conversation.latestUnreadID, anchor: .top) { result in
    conversation.finishOpening(result)
}
```

A thread normally opens on its last message. Give `chatInitialScrollTarget` the id of a message, the first unread one or the latest unread reply, and it opens there instead: the transcript stays hidden until that row is laid out, then appears with the message at the anchor. `.top` puts its first line under the header, which is what a long reply wants; `.center` and `.bottom` behave as they do in `ScrollViewReader`. Any message can be the target, a `messageAttachment { }` card included. A message too close to the end of the thread to reach the anchor opens the thread on its last row, as usual.

The id is read once, when the first messages are shown, so pass it together with them. After that the modifier leaves the thread alone: clearing your unread state (the id going to `nil`) or a new id from a later arrival does not scroll anything.

The message does not have to be loaded yet. If it is missing from the first messages, the transcript opens on the latest one and moves to the target when an update brings it, unless the reader has scrolled, tapped the field or sent in the meantime; pass `nil` to stop waiting.

Once positioned, the message keeps its place while a cached snapshot is reconciled with history, older pages land above it, cards change height, or new messages arrive below. The reader scrolling, tapping the field or sending ends that, and the transcript behaves as it always does from there. The `Chat`, its composer and any draft are untouched throughout.

`onResult` is called once: `.positioned` when the transcript is showing the message, `.interrupted` when the reader took over before the message arrived, and `.unreachable` when the message is further back than the transcript keeps loaded (about the newest 350 of the messages you pass), in which case the thread opened on the latest message.
