import SwiftChat
import SwiftUI
import UIKit

@MainActor
enum MessageMenu {
    @ChatContextMenuBuilder
    static func items(for id: UUID, in conversation: Conversation) -> [ChatContextMenuItem] {
        ChatContextMenuItem.tapbacks(conversation.reactions(on: id)) { emoji in
            conversation.toggleReaction(emoji, on: id)
        }
        if let text = conversation.text(of: id), !text.isEmpty {
            Divider()
            ChatContextMenuItem("Copy", systemImage: "doc.on.doc") {
                UIPasteboard.general.string = text
            }
        }
    }
}
