import SwiftChat
import UIKit

@MainActor
enum MessageMenu {
    static func items(for id: UUID, in conversation: Conversation) -> [ChatContextMenuItem] {
        var items: [ChatContextMenuItem] = [
            .tapbacks(conversation.reactions(on: id)) { emoji in
                conversation.toggleReaction(emoji, on: id)
            }
        ]

        if let text = conversation.text(of: id), !text.isEmpty {
            items.append(.separator)
            items.append(ChatContextMenuItem("Copy", systemImage: "doc.on.doc") {
                UIPasteboard.general.string = text
            })
        }

        return items
    }
}
