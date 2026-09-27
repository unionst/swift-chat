import Foundation

enum Demo: String, CaseIterable, Identifiable {
    case conversation
    case group
    case history
    case attachments
    case tinted
    case empty

    var id: String { rawValue }

    var title: String {
        switch self {
        case .conversation: "Conversation"
        case .group: "Group chat"
        case .history: "Long thread"
        case .attachments: "Attachments"
        case .tinted: "Your colors"
        case .empty: "Empty state"
        }
    }

    var summary: String {
        switch self {
        case .conversation: "Sending, receipts, typing dots, tapbacks, and a copy menu"
        case .group: "Avatars and names appear once three people are in the thread"
        case .history: "Older messages load as you reach the top"
        case .attachments: "Photos, a collage, and a plus button for photos and files"
        case .tinted: "Outgoing bubbles in a brand color"
        case .empty: "What a new conversation shows before the first message"
        }
    }

    var systemImage: String {
        switch self {
        case .conversation: "bubble.left.and.bubble.right"
        case .group: "person.3"
        case .history: "clock.arrow.circlepath"
        case .attachments: "photo.on.rectangle"
        case .tinted: "paintpalette"
        case .empty: "bubble"
        }
    }
}
