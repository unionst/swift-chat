---
name: swift-chat
description: Add an iMessage-faithful chat screen or an AI agent chat to an iOS app with Swift Chat, the free SwiftUI package from Union St. Use when the user asks for a chat UI, a messages screen, a conversation view, an AI assistant or agent thread, a ChatGPT-style streaming chat, iMessage-style bubbles, typing indicators, read receipts, or a chat input bar in SwiftUI. Covers installation, the Chat and Message API, every modifier, attachments, the assistant style, agent threads (streaming, tool-call status, result cards, suggestions, turn-taking), and the mistakes agents make most.
---

# Swift Chat

One SwiftUI view that renders a conversation the way the Messages app does: collated bubble tails, typing dots, delivery and read receipts, photos and files, tapbacks, group chats, pagination, and a keyboard that follows the finger. A UIKit collection view does the work underneath; SwiftUI is the only API you touch.

Free to use in any app. Closed source, shipped as a binary Swift package. iOS 18 or later, Xcode 26.1 or later. On the Mac it runs as a Mac Catalyst app (macOS 26 or later): in a multiplatform target replace the Mac destination with Mac (Mac Catalyst); a native AppKit destination cannot link it.

Full reference: https://unionst.com/swiftchat/llms-full.txt. Runnable examples: `Examples/SwiftChatDemo` in https://github.com/unionst/swift-chat.

## Install

Swift Package Manager, product `SwiftChat`:

```swift
dependencies: [
    .package(url: "https://github.com/unionst/swift-chat.git", from: "1.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SwiftChat", package: "swift-chat")
    ])
]
```

In Xcode: File › Add Package Dependencies › paste the URL. No other dependencies to add. Then `import SwiftChat`.

## Minimal screen

```swift
import SwiftUI
import SwiftChat

struct ConversationView: View {
    @State private var conversation = Conversation()

    var body: some View {
        Chat(conversation.messages) { message in
            Message(message.text, role: message.role, timestamp: message.sentAt)
                .messageStatus(message.status)
        }
        .chatTypingIndicators(conversation.typing)
        .chatInputPlaceholder("Message")
        .chatInputCapabilities([.photoLibrary, .files])
        .onChatSend { text, media in
            await conversation.send(text, media)
        }
    }
}

@MainActor @Observable
final class Conversation {
    var messages: [ChatMessage] = []
    var typing: [ChatRole] = []

    func send(_ text: String?, _ media: [MessageMedia]) async {
        let message = ChatMessage(text: text ?? "", role: .me, sentAt: .now, status: .sending)
        messages.append(message)
        await api.deliver(message, attachments: media)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var role: ChatRole
    var sentAt: Date
    var status: ChatDeliveryStatus?
}
```

`Chat` takes any `RandomAccessCollection` of `Identifiable` values and a closure that turns each one into a `Message`. The user's model stays theirs; nothing conforms to a protocol. Rows are keyed by the element's `id`, so keep ids stable.

## Roles

- `.me`: outgoing bubble on the right.
- `.user(id:displayName:)`: incoming bubble on the left; avatar and name appear automatically once three people are in the thread.
- `.system`: centered gray text, no bubble.

## Message modifiers

| Modifier | Effect |
|---|---|
| `messageStatus(_:)` | `.sending`, `.sent`, `.delivered`, `.read`, `.failed` under the bubble |
| `messageMedia(_:)` | One `MessageMedia` or an array; several images draw as one collage |
| `messageReactions(_:)` | Tapbacks drawn on the bubble |
| `messageAttachment { }` | Any SwiftUI view as the attachment |
| `messageHeader { }` / `messageFooter { }` | Views above or below the bubble |
| `messageAvatar { }` | Custom avatar for incoming messages |
| `messageStyle(_:)` | `.default` bubbles or `.plain` bare text |
| `font(_:)` | Bubble text font |
| `contextMenu { }` | Long-press menu for that message |
| `contentVersion(_:)` | Re-render when content changes but the id does not |

Attachments: `MessageMedia.image(url:width:height:blurhash:)` and `MessageMedia.file(url:name:size:mimeType:)`. Pass width and height for images so placeholders are sized before load. `image(url:)` accepts `https:`, `file:`, and `data:` URLs. `video`, `audio`, `location`, and `poll` exist on the enum but are not drawn yet; do not promise them.

## Chat modifiers

| Modifier | Effect |
|---|---|
| `chatInputPlaceholder(_:)` | Placeholder in the input field |
| `chatInputCapabilities(_:)` | `.camera`, `.photoLibrary`, `.files`, or `[]` for text only |
| `onChatSend { text, media in }` | Async send handler. `text` may be nil, `media` is `[MessageMedia]` and may be empty |
| `onChatTypingChanged { isTyping in }` | Send typing events to your server |
| `onChatInputTextChanged { text in }` | Keep a draft per thread; seed it back with `chatInitialInputText(_:)` |
| `chatTypingIndicators(_:)` | Typing dots for `[ChatRole]` |
| `chatHeader { }` | SwiftUI view pinned above the transcript |
| `chatEmptyView { }` | Shown when there are no messages |
| `chatAutoscrollBehavior(_:)` | `.whenAtBottom` (default), `.always`, `.never` |
| `chatLoadsOlderMessages { }` | Async loader at the top; return `false` when nothing older remains |
| `chatInitialScrollTarget(id:anchor:onResult:)` | Open on a message (first or latest unread) instead of the last one; it holds its place until the reader scrolls, taps the field or sends. Read once, with the first messages |
| `ChatHeaderPlacement.topMargin` (a static, not a modifier) | Room above the header on a folded phone (iPhone Duo), where the status bar is in a side column and nothing sits across the top. Set it to about 24 while `UITraitCollection.verticalBarEdge` is `.leading` or `.trailing`, zero otherwise. The side-column tab bar, a `NavigationSplitView` detail column and the plus menu need nothing from the host. |
| `ChatLayoutConstants.readableWidth` (a static, not a modifier) | The widest the conversation is drawn, for a Mac window, an iPad or a split view. Set it to about 720 and the rows and input bar stay centred at that width while the transcript scrolls across the whole pane. `nil` by default, which draws edge to edge. On a Mac, Return sends and Shift-Return makes a new line with nothing from the host. |
| `onChatScrollEdge(_:perform:)` | Top or bottom edge reached |
| `onMessagesEvictable { ids in }` | Off-screen ids safe to drop in huge threads |
| `chatMessageContextMenu { id in [ChatContextMenuItem] }` | Long-press menu items as data, keyed by message id |
| `onChatMessageTap { id in }` | Tap per message |
| `onChatFileTap { id, file in }` | Tap on a file bubble; without it the file opens in Quick Look |
| `chatSenderInfo(_:)` | `.automatic` (group chats only) or `.always` |
| `chatStyle(_:)` | `.messages` (default) or `.assistant` |
| `chatTypingStatus(_:)` | Status line beside the spinner in the assistant style |
| `chatInputBarHeight(_:)` | Resting height of the field |
| `chatInputControlTint(_:)` | Send button fill |
| `chatBubbleStyle(_:)` | Any `ShapeStyle` for outgoing bubbles; `.tint(_:)` also works |
| `chatIncomingBubbleStyle(_:)` | Any `ShapeStyle` for the bubbles other people send; `chatIncomingBubbleTextColor(_:)` sets their words |
| `chatBubbleShape(_:)` | Any `Shape` for every bubble in place of the rounded bubble and its tail, or a closure `{ bubble in … }` given `bubble.isFromMe` and `bubble.groupPosition` (`.alone`, `.first`, `.middle`, `.last`) |
| `chatAvatar { role in }` | The avatar for a participant, answered once for the whole transcript |
| `chatAvatarLayout(size:edge:showsOwnAvatar:)` | Avatar size (32 by default), `edge: .top` to stand it beside the first bubble of a run, `showsOwnAvatar: true` for an avatar beside the person's own messages (asked for through `chatAvatar` with `ChatRole.me`) |
| `chatAttachmentActions(_:)` | Sources of your own beside Camera, Photos and Files |
| `chatAttachmentMenuStyle(_:)` | `.menu` (default) or `.grid`: the plus button's sources as round buttons in a panel at the keyboard's height |
| `chatInputPanel(isPresented:label:content:)` | A panel of your own in the keyboard's place, with its button beside the plus. Several calls give several panels |
| `chatBubbleTailsHidden(_:)` | Hide tails |
| `chatInputBarTint(_:)` | Translucent tint over the input bar's glass |
| `chatHapticsDisabled(_:)` | No tap on incoming messages |
| `chatPaginationAnimated(_:)` | Animate bubbles during rapid bursts |

## Assistant style, for AI threads

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

The user's question rises to the top and the reply streams in beneath it as bare Markdown text (headings, lists, bold, links, code blocks render). Stream a reply by appending one message and rewriting its text as tokens arrive; the row grows in place. Show the spinner by passing the assistant's role in `typingUsers` while it works, and a status like "Searching" with `chatTypingStatus(_:)`.

## Agent threads

Swift Chat has no model or networking inside it. The host runs the agent; these pieces draw it. They work in the assistant style and in ordinary bubbles. Full guide: `Documentation/agents.md`.

```swift
Chat(thread.messages, typingUsers: thread.working ? [agent] : []) { message in
    if let result = message.result {
        Message(message.text, role: message.role, timestamp: message.sentAt)
            .messageAttachment { ResultCard(result) }
    } else if message.isSuggestion {
        Message(message.text, role: .me, timestamp: message.sentAt)
            .messageStyle(.suggestion)
    } else {
        Message(message.text, role: message.role, timestamp: message.sentAt)
    }
}
.chatStyle(.assistant)
.chatTypingStatus(thread.status)
.chatInputSuggestions(thread.messages.isEmpty ? thread.openers : [])
.onChatSend { text, media in
    await thread.send(text, media)
}
```

- **Tool-call status.** Set the string behind `chatTypingStatus(_:)` at each tool call ("Checking your calendar", "Searching"); the old line rolls away. `nil` shows the spinner alone. It only shows while the agent's role is in `typingUsers`. In the messages style put it in `ChatHeader(title:subtitle:)`.
- **Results as views.** `messageAttachment { }` puts any SwiftUI view in the thread as a message, with live controls: a booking, a chart, a form. Use a message with empty text for a card on its own.
- **Suggestion chips.** `chatInputSuggestions([ChatInputSuggestion(text:systemImage:)])` stacks chips above the field while nothing is typed. A tap sends the chip the way the send button does and its text arrives in `onChatSend`. Set `onChatInputSuggestionTap` only to take the tap yourself, for a chip that fills the field or opens a picker.
- **Suggestion bubbles.** A `Message` with `.messageStyle(.suggestion)` is a dashed outline on the person's side. A tap sends its text through the input bar and it arrives in `onChatSend`; remove the suggestion rows there.
- **Turn-taking**, for an agent that texts in bubbles like a person:

```swift
@MainActor @Observable
final class CoachThread {
    var messages: [ThreadMessage] = []

    @ObservationIgnored lazy var turns = ChatAssistantTurns(
        exchange: { [unowned self] in try await model.reply(to: messages) },
        deliver: { [unowned self] line in messages.append(ThreadMessage(text: line, role: coach)) },
        fail: { error in print(error) }
    )

    func send(_ text: String) {
        messages.append(ThreadMessage(text: text, role: .me))
        turns.noteSent()
    }
}

Chat(thread.messages, typingUsers: thread.turns.typingUsers(coach)) { message in
    Message(message.text, role: message.role, timestamp: message.sentAt)
}
.chatAssistantTurns(thread.turns)
.onChatSend { text, _ in
    guard let text else { return }
    await thread.send(text)
}
```

`exchange` returns the reply as an array of lines. The controller raises the dots 1.6 s after a send, holds the reply while the person is typing, gathers a burst of messages into one `exchange`, passes a reply made stale by a follow-up to `shelve`, and delivers lines one at a time. Tune it with `ChatAssistantTurns(pacing: ChatAssistantPacing(...))`.

## Mistakes to avoid

- `chatTypingIndicators(_:)` is a method on `Chat` itself. Apply it directly to `Chat(...)` before other modifiers, or pass `typingUsers:` in the initializer.
- Do not wrap `Chat` in a `ScrollView` or `List`. It scrolls itself and owns the keyboard.
- Do not add your own keyboard avoidance or `safeAreaInset` input bar. The input bar is built in; `onChatSend` is how you receive input.
- `onChatSend` gives `media` as an array. Older docs showed a single optional; that is gone.
- Use `chatMessageContextMenu` (data) for per-row menus; a SwiftUI `contextMenu` inside a hosted cell can swallow taps.
- Keep message ids stable across renders, or rows lose their height and delivery label.
- A chip from `chatInputSuggestions` and a tapped `.suggestion` row are both sent for you and arrive in `onChatSend`: do not send them again from `onChatInputSuggestionTap` or `onChatMessageTap`.
- `import SwiftChat`. The older `import UnionChat` still compiles but is deprecated.
