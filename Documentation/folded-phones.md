# Folded phones

[Swift Chat](../README.md) › Folded phones

A folded phone (iPhone Duo, iOS 27.1) moves its status bar and tab bar into a column along one edge, and unfolds into a window wide enough for two columns. The chat reads both layouts itself:

- A tab bar standing in the side column is beside the chat, so the input bar rests at the bottom of the screen instead of holding a tab bar’s room beneath it.
- Unfolded, the chat works as the detail column of a `NavigationSplitView`. The plus menu opens centred on its plus, over the thread it belongs to.
- The photo panel’s grid runs under the side column.

The one thing the host says is where the header starts. With the status bar in the column there is nothing across the top, so the header would sit against the screen’s edge. Give it the room system apps leave there:

```swift
ChatHeaderPlacement.topMargin = hasSideColumn ? 24 : 0
```

`hasSideColumn` is yours to read: `UITraitCollection.verticalBarEdge` is `.leading` or `.trailing` while the column stands. The margin is zero by default, and on a phone with a status bar across the top it should stay zero.
