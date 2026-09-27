import Foundation
import Observation
import SwiftChat

@MainActor @Observable
final class Conversation {
    var messages: [DemoMessage]
    var typing: [ChatRole] = []

    private let partner: ChatRole?
    private var replies: [String]
    private var olderPagesLeft: Int

    private static let me = ChatReaction.Person(id: "me", name: "You")

    init(
        messages: [DemoMessage] = [],
        partner: ChatRole? = nil,
        replies: [String] = [],
        olderPages: Int = 0
    ) {
        self.messages = messages
        self.partner = partner
        self.replies = replies
        self.olderPagesLeft = olderPages
    }

    func send(_ text: String?, _ media: [MessageMedia]) async {
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty || !media.isEmpty else { return }

        let message = DemoMessage(text: trimmed, role: .me, status: .sending, media: media)
        messages.append(message)

        try? await Task.sleep(for: .milliseconds(600))
        setStatus(.delivered, for: message.id)

        guard let partner, !replies.isEmpty else { return }

        try? await Task.sleep(for: .milliseconds(900))
        setStatus(.read, for: message.id)
        typing = [partner]

        try? await Task.sleep(for: .milliseconds(1800))
        typing = []
        messages.append(DemoMessage(text: replies.removeFirst(), role: partner))
    }

    func loadOlderPage() async -> Bool {
        guard olderPagesLeft > 0, let oldest = messages.first?.sentAt else { return false }

        try? await Task.sleep(for: .milliseconds(700))
        messages.insert(contentsOf: SampleThreads.olderPage(before: oldest), at: 0)
        olderPagesLeft -= 1
        return olderPagesLeft > 0
    }

    func toggleReaction(_ emoji: String, on id: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }

        let hadSame = messages[index].reactions.contains { $0.isMine && $0.emoji == emoji }
        var reactions = messages[index].reactions.compactMap { reaction -> ChatReaction? in
            guard reaction.isMine else { return reaction }
            let others = reaction.people.filter { $0.id != Self.me.id }
            return others.isEmpty ? nil : ChatReaction(emoji: reaction.emoji, people: others, isMine: false)
        }

        if !hadSame {
            if let existing = reactions.firstIndex(where: { $0.emoji == emoji }) {
                reactions[existing] = ChatReaction(
                    emoji: emoji,
                    people: reactions[existing].people + [Self.me],
                    isMine: true
                )
            } else {
                reactions.append(ChatReaction(emoji: emoji, people: [Self.me], isMine: true))
            }
        }

        messages[index].reactions = reactions
    }

    func text(of id: UUID) -> String? {
        messages.first { $0.id == id }?.text
    }

    func reactions(on id: UUID) -> [ChatReaction] {
        messages.first { $0.id == id }?.reactions ?? []
    }

    private func setStatus(_ status: ChatDeliveryStatus, for id: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].status = status
    }
}
