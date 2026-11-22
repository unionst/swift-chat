<div align="center">

# Swift Chat

The Messages app, as a SwiftUI view. For conversations with people, and with agents.

[Try it on your phone](https://testflight.apple.com/join/57bKq9jd) · [unionst.com/swiftchat](https://unionst.com/swiftchat) · [Documentation](https://www.swiftipedia.org/documentation/unionchat) · [llms.txt](https://unionst.com/swiftchat/llms.txt) · by [Union St](https://unionst.com)

<img src="assets/swift-chat.gif" width="300" alt="A Swift Chat conversation on iPhone: typing dots, three messages sent in a row, Delivered turning into Read">&nbsp;&nbsp;&nbsp;<img src="assets/agent.gif" width="300" alt="An agent thread in Swift Chat: suggestion chips, a status line rolling through three tool steps, a Markdown reply streaming in, a reservation card, and a confirmation after a suggested follow-up is tapped">

</div>

Swift Chat is a drop-in SwiftUI chat UI for iOS, for messaging apps and for AI agents. Hand it your messages and it renders them the way Messages does: bubble tails that land on the last message in a run, typing dots, delivery and read receipts, photo and file attachments, a keyboard that follows your finger, and a scroll with real weight to it. A UIKit collection view does the work underneath. SwiftUI is the only API you touch.

It is also the chat an agent lives in. One modifier, `.chatStyle(.assistant)`, turns the same view into the layout Siri and ChatGPT use, and the rest of an agent thread is built in: replies that stream in as Markdown, a status line that follows the agent through its tool calls, results drawn as your own SwiftUI views, suggestions to tap instead of type, and turn-taking that waits for you to finish typing. See [Building an agent](#building-an-agent), the [assistant style](https://unionst.com/swiftchat/assistant), and the [starter app that streams Claude](https://github.com/unionst/swift-chat-ai-starter).

[Installation](#installation) · [Quick start](#quick-start) · [Building an agent](#building-an-agent) · [Example app](#example-app) · [Apps using Swift Chat](#apps-using-swift-chat) · [Guides](#guides)

## What’s built in

- **Bubbles** with automatic tail placement, grouping by sender, and timestamp separators.
- **Typing indicators** for one person or a crowd.
- **Delivery states**: sending, sent, delivered, read, failed.
- **Attachments**: photos with BlurHash placeholders, several photos as one collage, and files.
- **Tapbacks**: reactions drawn on the bubble and picked from the long-press menu.
- **Replies**: swipe a message to reply, the original quoted above the answer, a “1 Reply” count under it, and the thread over the blurred conversation, the way Messages does it.
- **The input bar**: text, dictation, a plus menu for photos and files that opens over the keyboard, and an async send hook.
- **Keyboard handling**: interactive dismissal and safe-area management that matches Messages.
- **Group chats**: avatars and sender names appear on their own once three people are in the thread.
- **Pagination**: load older messages at the top with a built-in spinner.
- **Context menus and taps** delivered through UIKit’s own event path, so they always fire.
- **Haptics** on incoming messages, a scroll-to-bottom button, an empty state, and custom headers.
- **Dark mode, Dynamic Type, and the iOS 26 glass look**, because it is built from the system’s own materials.

And for an agent:

- **An assistant style**: your question rises to the top and the answer streams in beneath it, the way Siri and ChatGPT answer.
- **Streaming Markdown**: headings, lists, links, quotes, and code blocks, each word fading in as it arrives.
- **A status line** beside the spinner that rolls from one tool call to the next: “Checking your calendar”, “Searching”.
- **Results as views**: any SwiftUI view in the thread as a message, for a booking, a chart, or a form with live buttons.
- **Suggestions**: chips above the input bar, and dashed bubbles in the thread. A tap sends either one, and its bubble leaves from where the suggestion stood.
- **Turn-taking**: the dots wait a beat, the reply is held while you are still typing, and three messages in a row are answered once.

## Requirements

- iOS 18 or later
- On the Mac, a Mac Catalyst app on macOS 26 or later. See [On the Mac](Documentation/mac.md).
- Xcode 26.1 or later. The binary’s module interface is built with Swift 6.2, and an older compiler cannot read it.

## Installation

In Xcode choose File › Add Package Dependencies and paste:

```
https://github.com/unionst/swift-chat.git
```

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/unionst/swift-chat.git", from: "1.0.0")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "SwiftChat", package: "swift-chat")
        ]
    )
]
```

Swift Chat has no package dependencies of its own. The binary carries everything it needs, so there is nothing else to add, link, or embed.

## Quick start

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
        .chatInputPlaceholder("iMessage")
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

`Chat` accepts any `RandomAccessCollection` of `Identifiable` values plus a closure that turns each one into a `Message`. Your model stays yours; nothing has to conform to a protocol.

### Declarative form

Messages can also be written out directly, with the same conditionals and loops you use in SwiftUI:

```swift
Chat {
    Message("Welcome to support", role: .system, timestamp: .now)

    ForEach(messages) { message in
        Message(message.text, role: message.role, timestamp: message.sentAt)
    }

    if showHint {
        Message("Ask anything.", role: .user(id: "bot", displayName: "Assistant"), timestamp: .now)
    }
}
```

### Identity

Every row is keyed by a `Message.id`. In the collection form above, and inside a `ForEach`, that id is your element’s own `id`, so it stays stable as long as your model’s does. A `Message` written out bare in the declarative form gets a fresh identity on every render; set its `id` yourself when you rebuild it across renders and want the row to keep its place, its height, and its delivery label.

### Roles

| Role | Rendered as |
|---|---|
| `.me` | Outgoing bubble on the right |
| `.user(id:displayName:)` | Incoming bubble on the left, with avatar and name in group chats |
| `.system` | Centered gray text with no bubble |

## Building an agent

```swift
Chat(thread.messages, typingUsers: thread.working ? [agent] : []) { message in
    if let result = message.result {
        Message(message.text, role: message.role, timestamp: message.sentAt)
            .messageAttachment { ResultCard(result) }
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

That is the screen in the second recording at the top. Swift Chat has no model or network inside it, so the agent is yours; these are the pieces that draw it:

- **Stream the reply** by appending one message and rewriting its text as tokens arrive. It renders as Markdown and grows in place.
- **Say which step it is on** with `chatTypingStatus(_:)`. Set it at each tool call and the old line rolls away.
- **Show a result** with `messageAttachment { }`, which puts any SwiftUI view in the thread, buttons included.
- **Offer the next message** with `chatInputSuggestions(_:)` above the bar, or a `Message` with `.messageStyle(.suggestion)` in the thread. A tap sends either one the way the send button does.
- **Take turns** with `ChatAssistantTurns`, for an agent that texts like a person: it waits for you to stop typing, answers a burst of messages once, and never shows a reply to a message you have since followed up.

[Agent chats](Documentation/agents.md) covers each of these, in the assistant style and in ordinary bubbles. To start from a working app, clone the [starter that streams Claude](https://github.com/unionst/swift-chat-ai-starter).

## Example app

[Try it on your phone](https://testflight.apple.com/join/57bKq9jd) through TestFlight, no Xcode needed. It is [Examples/SwiftChatDemo](https://github.com/unionst/swift-chat/tree/main/Examples/SwiftChatDemo), a runnable app with seven screens: a conversation with delivery receipts and typing dots, a group chat, a long thread that loads older messages, attachments, custom colors, an empty state, and an assistant thread in the assistant style. To run it yourself, clone this repository, open `Examples/SwiftChatDemo/SwiftChatDemo.xcodeproj`, and run.

## Apps using Swift Chat

| Rate.fm | Tally | Jester |
|:-:|:-:|:-:|
| <img src="assets/apps/rate-fm.gif" width="240" alt="Rate.fm: press and hold a message, a tapback bar unfurls on glass, a reaction is added and the bubbles make room"> | <img src="assets/apps/tally.gif" width="240" alt="Tally: typing a request to the coach, typing dots, and the reply arriving as a food card in a bubble"> | <img src="assets/apps/jester.gif" width="240" alt="Jester: a chat with Jesse, Delivered becoming Read, typing dots, and the reply arriving line by line"> |
| Group chat with tapbacks on glass | The coach chat, with replies as custom attachment views | An AI conversation, streamed in line by line |

- [Rate.fm](https://apps.apple.com/us/app/rate-fm-rate-your-music/id6756295934): a diary of every album you listen to, where friends send each other records in a message.
- [Tally](https://apps.apple.com/us/app/tally-calorie-lift-coach/id6808934757): a calorie and training journal you keep by texting a coach.
- [Jester](https://apps.apple.com/us/app/jester-ai-rizz-keyboard/id6759629485): an AI dating coach you text for what to say next.
<!--
Add your app on a new line directly above this comment, in the same form:
- [Name](link): what it is, in a sentence.
The link goes to the App Store, a public TestFlight invitation, or the app’s site.
-->

Shipping Swift Chat in your app? Put it on this list with a pull request:

1. [Edit this README](https://github.com/unionst/swift-chat/edit/main/README.md). GitHub makes the fork for you.
2. Add one line at the end of the list: `- [Name](link): what it is, in a sentence.`
3. Open the pull request and say which screen of the app is Swift Chat. Attach a short screen recording of it if you have one, and it can join the row above.

Any app people can get today belongs here, whatever its size: on the App Store, behind a public TestFlight link, or on its own site.

## Guides

The quick start above is enough for a working conversation. Each of these covers one part of the API in full:

- [Messages](Documentation/messages.md): message modifiers, attachments, tapbacks and the long-press menu, replies.
- [Chat modifiers](Documentation/chat-modifiers.md): every modifier on `Chat`, grouped into the input bar, the transcript, taps and menus, and appearance.
- [Loading older messages](Documentation/loading-older-messages.md): pagination and its spinner.
- [Opening on a message](Documentation/opening-on-a-message.md): start a thread on the first unread message instead of the last one.
- [Headers](Documentation/headers.md): your own header, the built-in `ChatHeader`, and group avatars.
- [Agent chats](Documentation/agents.md): streaming, the status line through tool calls, results as views, suggestions, and turn-taking.
- [Assistant style](Documentation/assistant-style.md): the layout for AI threads, with Markdown replies, streaming, and a status line.
- [Folded phones](Documentation/folded-phones.md): the side column and split view on iPhone Duo.
- [On the Mac](Documentation/mac.md): Mac Catalyst, Return to send, and a readable width.
- [Keeping the main thread free](Documentation/main-thread.md): what to keep out of your callbacks, and a watchdog that tells you when it slips.
- [UI testing](Documentation/ui-testing.md): accessibility identifiers for the input bar.

## For AI coding agents

Swift Chat ships an agent skill. Install it into Claude Code, Cursor, Codex, or any client that reads the open skills format:

```
npx skills add unionst/swift-chat
```

That gives your agent the full API, the assistant-style pattern, and the mistakes to avoid, so “add a chat screen with Swift Chat” works in one prompt. There is also an [llms.txt](https://unionst.com/swiftchat/llms.txt) and a [full reference](https://unionst.com/swiftchat/llms-full.txt) if you’d rather paste a link:

```
Add Swift Chat to this iOS app. Package URL https://github.com/unionst/swift-chat.git,
product "SwiftChat", iOS 18+. Read https://unionst.com/swiftchat/llms-full.txt first, then build the
conversation screen with Chat(messages) { Message($0.text, role: $0.role, timestamp: $0.sentAt) }
and wire sending with .onChatSend.
```

## Migrating from UnionChat

Swift Chat was previously published as UnionChat. The package keeps a `UnionChat` product, so `import UnionChat` still compiles; the old repository URL redirects here. New code should depend on the `SwiftChat` product and `import SwiftChat`. No types were renamed.

## License

Swift Chat is free to use in any app, including commercial ones, and ships as a closed-source binary the same way Apple distributes its own frameworks. See [LICENSE](LICENSE) for the short version of what that means. Teams that want source access or custom terms can write to [hello@unionst.com](mailto:hello@unionst.com).

<div align="center">

Made by [Union St](https://unionst.com)

</div>
