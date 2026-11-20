# On the Mac

[Swift Chat](../README.md) › On the Mac

Swift Chat runs on the Mac as a Mac Catalyst app, from the same package and with the same API. Nothing in your chat code changes.

In a multiplatform target, open the target’s General tab and under Supported Destinations replace **Mac** with **Mac (Mac Catalyst)**. The transcript is built on UIKit, so a native AppKit destination has no build of the package to link; Catalyst is the Mac destination that does.

What the chat does differently on a Mac:

- Return sends, and Shift-Return or Option-Return makes a new line. Return while an input method is composing confirms the composition.
- The transcript follows the window as it is resized, and a thread resting on its last message stays there.

A Mac window can be far wider than a phone, which puts the two sides of a conversation at opposite edges of the screen. Cap how wide the conversation is drawn and it stays centred while the transcript still scrolls across the whole pane:

```swift
ChatLayoutConstants.readableWidth = 720
```

It is `nil` by default, which draws edge to edge. The same line suits an iPad or a split view.
