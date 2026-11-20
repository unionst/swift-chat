# Keeping the main thread free

[Swift Chat](../README.md) › Keeping the main thread free

A keystroke the main thread is too busy to take is a dropped letter, and a sentence with dropped letters reads as typos. Swift Chat keeps its own work off the keystroke path: a keystroke re-evaluates the input bar alone, not the transcript or your header; the field’s height is measured once per edit; photos and files are decoded, resized, and copied on a background task before they are staged; the transcript diffs its rows only when a message actually changed.

Your side of the chat matters as much, because every callback and view body below runs on the main actor:

- `onChatSend` is async so that you can `await` your network call, but the code before its first `await` runs on the main actor at the moment of the tap. Append the message and return; encode JSON, write files, resize images, and talk to the network on a background task or an actor.
- `onChatInputTextChanged` fires on every keystroke. Store the string and return. Save drafts on a pause or on dismissal, not per keystroke.
- `onChatTypingChanged` fires as the field fills and empties. Send the typing event; do not persist or lay out anything there.
- Row views, the header, and the empty view are re-evaluated when a message changes. Keep their bodies to layout: no date parsing, no image decoding, no file reads, no `Calendar`, `DateFormatter`, or `JSONDecoder` created in a body. Compute once and store on the model.
- Keep message models cheap to compare. The transcript fingerprints each row’s id, role, time, delivery status, text, and reactions on every evaluation; a model whose properties are computed on access pays that cost per row.
- Do not force layout from a callback (`layoutIfNeeded`, reading frames through `UIView` hierarchies) while the keyboard is up.

To see when it slips, apply `.chatMainThreadWatchdog()` in debug builds:

```swift
Chat(messages)
    .chatMainThreadWatchdog(.milliseconds(100))
```

While the field is first responder a probe off the main thread asks it, every 50 ms, to run an empty block. An answer later than the threshold is logged to the unified log (subsystem `com.unionst.swift-chat`, category `MainThread`) with the stall’s length and the last thing the chat was doing (a keystroke, a send, or one of your callbacks) and how long before the stall it began, and is emitted as an Instruments signpost. It is off unless applied, and adds nothing to a release build that leaves it out.
