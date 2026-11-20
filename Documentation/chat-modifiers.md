# Chat modifiers

[Swift Chat](../README.md) › Chat modifiers

All of these are ordinary SwiftUI view modifiers applied to `Chat`.

## The input bar

| Modifier | What it does |
|---|---|
| `chatInputPlaceholder(_:)` | Placeholder text in the input field. Default is “Message”. |
| `chatInputCapabilities(_:)` | Which attachments the plus button offers: `.camera`, `.photoLibrary`, `.videoLibrary`, `.files`, or `[]` for text only |
| `chatCameraPresented(_:)` | A binding that opens the camera from the outside, the way the plus menu’s Camera row does |
| `onChatSend { text, media in }` | Async handler called when the user sends. `text` may be nil; `media` is an array and may be empty. |
| `onChatTypingChanged { isTyping in }` | True while the field holds text, false once it is sent or cleared |
| `onChatInputTextChanged { text in }` | Fires with the input field’s text on every change |

- **Videos.** Add `.videoLibrary` beside `.photoLibrary` and videos join the Photos sheet, arriving in `onChatSend` as `.video(url:thumbnailURL:duration:)` with a local file URL.
- **Opening the camera yourself.** Set the `chatCameraPresented` binding to `true` and the bar brings the camera up, then puts it back to `false` when the camera closes. It needs `.camera` in `chatInputCapabilities`. A host uses it to land in a thread with the camera already up, say from a lock screen Control.
- **Typing.** A draft left sitting in the field is still typing, so an assistant can hold its reply until the field is clear. `onChatTypingChanged(idleAfter:)` is the keystroke form for the indicator another person sees: true on an edit, false after `idleAfter` without one.
- **Drafts.** Use `onChatInputTextChanged` to keep a draft per thread and seed it back with `chatInitialInputText`.

## The transcript

| Modifier | What it does |
|---|---|
| `chatTypingIndicators(_:)` | Shows typing dots for the given `[ChatRole]` |
| `chatHeader { }` | A SwiftUI view pinned above the transcript. See [Headers](headers.md). |
| `chatEmptyView { }` | What to show when there are no messages. Laid out at the transcript’s width, so text wraps. |
| `chatSenderInfo(_:)` | `.automatic` shows avatars and names in group chats only; `.always` shows them everywhere |
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
| `chatBubbleTailsHidden(_:)` | Hides bubble tails |
| `chatInputBarHeight(_:)` | The message field’s resting height. 40 by default, 46 in the assistant style. |
| `chatInputControlTint(_:)` | The send button’s fill. The accent color by default, the label color in the assistant style. |
| `chatInputBarTint(_:)` | A translucent tint over the input bar’s glass |
| `chatHapticsDisabled(_:)` | Turns off the tap on incoming messages |
| `chatPaginationAnimated(_:)` | Whether bubbles animate during rapid bursts of messages |

## Debugging

| Modifier | What it does |
|---|---|
| `chatMainThreadWatchdog(_:)` | In debug builds, logs a main-thread stall longer than the threshold (100 ms by default) while the field has the keyboard, with the last thing the chat was doing. See [Keeping the main thread free](main-thread.md). |
