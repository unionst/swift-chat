# Chat modifiers

[Swift Chat](../README.md) › Chat modifiers

All of these are ordinary SwiftUI view modifiers applied to `Chat`.

## The input bar

| Modifier | What it does |
|---|---|
| `chatInputPlaceholder(_:)` | Placeholder text in the input field. Default is “Message”. |
| `chatInputCapabilities(_:)` | Which attachments the plus button offers: `.camera`, `.photoLibrary`, `.videoLibrary`, `.files`, or `[]` for text only |
| `chatCameraPresented(_:)` | A binding that opens the camera from the outside, the way the plus menu’s Camera row does |
| `chatAttachmentActions(_:)` | Sources of your own beside Camera, Photos and Files, each a `ChatAttachmentAction` with a title, a symbol and what to run |
| `chatAttachmentMenuStyle(_:)` | How the plus shows its sources: `.menu` (default) pops them up from the button, `.grid` lays them out as round buttons in a panel that stands in the keyboard’s place |
| `chatInputPanel(isPresented:label:content:)` | A panel of your own in the keyboard’s place, with a button beside the plus that raises it and puts it away. Each call adds a panel and its button, in the order written. See [Panels in the keyboard’s place](#panels-in-the-keyboards-place). |
| `onChatSend { text, media in }` | Async handler called when the user sends. `text` may be nil; `media` is an array and may be empty. |
| `onChatTypingChanged { isTyping in }` | True while the field holds text, false once it is sent or cleared |
| `onChatInputTextChanged { text in }` | Fires with the input field’s text on every change |
| `chatInputSuggestions(_:)` | Chips stacked above the field while nothing is typed, each a whole message. A tap sends it the way the send button does: its bubble leaves from the chip and the words arrive in `onChatSend`. See [Agent chats](agents.md#offer-the-next-message). |
| `onChatInputSuggestionTap { suggestion in }` | Takes a chip’s tap in place of sending it, for a chip that fills the field or opens a picker |

- **Videos.** Add `.videoLibrary` beside `.photoLibrary` and videos join the Photos sheet, arriving in `onChatSend` as `.video(url:thumbnailURL:duration:)` with a local file URL.
- **Opening the camera yourself.** Set the `chatCameraPresented` binding to `true` and the bar brings the camera up, then puts it back to `false` when the camera closes. It needs `.camera` in `chatInputCapabilities`. A host uses it to land in a thread with the camera already up, say from a lock screen Control.
- **Typing.** A draft left sitting in the field is still typing, so an assistant can hold its reply until the field is clear. `onChatTypingChanged(idleAfter:)` is the keystroke form for the indicator another person sees: true on an edit, false after `idleAfter` without one.
- **Drafts.** Use `onChatInputTextChanged` to keep a draft per thread and seed it back with `chatInitialInputText`.

### Panels in the keyboard’s place

A panel stands exactly where the keyboard stands, the way the Photos sheet does, so the input bar holds still when one replaces the other. A tap on the field hands back to the keyboard; a tap on the panel’s button, or a drag down, closes it.

```swift
Chat(messages)
    .chatInputCapabilities([.photoLibrary, .camera, .files])
    .chatAttachmentActions(extraActions)
    .chatAttachmentMenuStyle(.grid)
    .chatInputPanel(isPresented: $showsStickers) {
        Image(systemName: "face.smiling")
    } content: {
        StickerPanel()
    }
```

Here the plus opens a grid of sources and the smiley opens the stickers. A bar can carry several `chatInputPanel`s; raising one puts away whichever was up. In the grid, Photos opens the Photos sheet in the same place and every other source closes the panel and runs.

## The transcript

| Modifier | What it does |
|---|---|
| `chatTypingIndicators(_:)` | Shows typing dots for the given `[ChatRole]` |
| `chatHeader { }` | A SwiftUI view pinned above the transcript. See [Headers](headers.md). |
| `chatEmptyView { }` | What to show when there are no messages. Laid out at the transcript’s width, so text wraps. |
| `chatSenderInfo(_:)` | `.automatic` shows avatars and names in group chats only; `.always` shows them everywhere |
| `chatAvatar { role in }` | The avatar for a participant, answered once for the whole transcript. Without it a message’s own `messageAvatar { }` is used, then initials in a circle. |
| `chatAvatarLayout(size:edge:showsOwnAvatar:)` | Where avatars stand and how big they are. 32 pt beside the last bubble of a run by default; `edge: .top` puts them beside the first, level with the name or `messageHeader { }`, and `showsOwnAvatar: true` draws yours on the trailing side of your own messages (asked for through `chatAvatar` with `ChatRole.me`). |
| `chatAutoscrollBehavior(_:)` | `.whenAtBottom` (default), `.always`, or `.never`. A scroll-to-bottom button appears when needed. |
| `chatLoadsOlderMessages { }` | Async loader called at the top of the transcript. Return `false` when nothing older remains. See [Loading older messages](loading-older-messages.md). |
| `chatHasOlderMessages(_:)` | Whether anything older exists, when you know. `false` draws no spinner, `true` keeps it waiting, `nil` leaves it to the loader’s answer. |
| `chatInitialScrollTarget(id:anchor:onResult:)` | Opens the transcript on a message instead of on the latest one, and keeps it there while history fills in around it. See [Opening on a message](opening-on-a-message.md). |
| `onChatScrollEdge(_:perform:)` | Callback when the reader reaches the top or bottom edge |
| `onMessagesEvictable { ids in }` | Tells you which off-screen message ids can be dropped in very long threads |

## Taps and menus

| Modifier | What it does |
|---|---|
| `chatMessageContextMenu { id in … }` | The long-press menu per message, written as a result builder of `ChatContextMenuItem`s with `Divider()` between groups. See [Tapbacks and the long-press menu](messages.md#tapbacks-and-the-long-press-menu). |
| `onChatMessageTap { id in }` | Tap handler per message |
| `onChatFileTap { id, file in }` | Tap handler for a file bubble, with the message id and the exact `.file` tapped. Without it a tap opens the file in Quick Look. |
| `onChatReply { parentID, text, media in }` | Turns on swipe to reply and threads, and receives a send made inside a thread. See [Replies](messages.md#replies). |

## Appearance

| Modifier | What it does |
|---|---|
| `chatStyle(_:)` | `.messages` (default) or `.assistant`: a sent message rises to the top and the reply streams in beneath it as bare text. See [Assistant style](assistant-style.md). |
| `chatTypingStatus(_:)` | A line beside the typing indicator in the assistant style saying what is happening. A new status rolls the old one up and out. |
| `chatBubbleStyle(_:)` | Any `ShapeStyle` for outgoing bubbles. `.tint(_:)` also works. |
| `chatIncomingBubbleStyle(_:)` | Any `ShapeStyle` for the bubbles other people send, and the typing indicator. Gray by default; a translucent fill suits a transcript over a background of your own. |
| `chatIncomingBubbleTextColor(_:)` | The color of the words in those bubbles. The label color by default. |
| `chatBubbleShape(_:)` | One outline for every bubble in place of the rounded bubble and its tail: any `Shape`, or a closure that picks one per bubble. See [Bubble shape](#bubble-shape). |
| `chatBubbleTailsHidden(_:)` | Hides bubble tails |
| `chatInputBarHeight(_:)` | The message field’s resting height. 40 by default, 46 in the assistant style. |
| `chatInputControlTint(_:)` | The send button’s fill. The accent color by default, the label color in the assistant style. |
| `chatInputBarTint(_:)` | A translucent tint over the input bar’s glass |
| `chatHapticsDisabled(_:)` | Turns off the tap on incoming messages |
| `chatPaginationAnimated(_:)` | Whether bubbles animate during rapid bursts of messages |
| `chatSendFlightDriver(_:)` | What moves a sent bubble from the input bar to its row: `.displayLink` (default) draws it on the main thread every refresh, `.renderServer` hands the same curve to Core Animation when the flight starts, so the bubble keeps moving while the app is busy with the send |

### Bubble shape

`chatBubbleShape(_:)` takes any `Shape`, and text bubbles, photos, files, cards, reply quotes, the long-press preview and the bubble that flies up from the input bar all take it:

```swift
Chat(messages)
    .chatBubbleShape(.rect(cornerRadius: 12))
```

Pass a closure instead and it is told whose bubble it is drawing and where that bubble stands in its run of consecutive messages, so a corner can point at whoever spoke, or the bubbles of one run can close up against each other:

```swift
Chat(messages)
    .chatBubbleShape { bubble in
        UnevenRoundedRectangle(
            topLeadingRadius: bubble.isFromMe ? 18 : 5,
            bottomLeadingRadius: 18,
            bottomTrailingRadius: 18,
            topTrailingRadius: bubble.isFromMe ? 5 : 18,
            style: .continuous
        )
    }
```

`ChatBubbleShapeConfiguration` carries `isFromMe`, `groupPosition` (`.alone`, `.first`, `.middle` or `.last`), and `startsGroup` and `endsGroup` for the common questions. The closure runs each time a bubble is drawn, so answer from the configuration alone. A custom shape has no tail.

## Agents

| Modifier | What it does |
|---|---|
| `chatAssistantTurns(_:)` | Hands the field’s typing to a `ChatAssistantTurns`, which runs an agent’s side of the thread: the dots wait a beat, the reply is held while the person is typing, and a burst of messages is answered once. See [Agent chats](agents.md#take-turns-the-way-a-person-does). |
| `chatAssistantTyping(_:perform:)` | The typing gate alone, a `ChatAssistantTyping`, for a host that runs its own exchange |
| `chatSuggestionFill(_:)` | A fill behind every `.suggestion` bubble, under its dashed outline, for a thread drawn over a photo or a blur. `nil` (default) draws the outline alone. |

`chatStyle(.assistant)` and `chatTypingStatus(_:)` are under [Appearance](#appearance), and `chatInputSuggestions(_:)` is under [The input bar](#the-input-bar).

## Debugging

| Modifier | What it does |
|---|---|
| `chatMainThreadWatchdog(_:)` | In debug builds, logs a main-thread stall longer than the threshold (100 ms by default) while the field has the keyboard, with the last thing the chat was doing. See [Keeping the main thread free](main-thread.md). |
