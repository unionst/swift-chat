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

    private func setStatus(_ status: ChatDeliveryStatus, for id: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == id }) else { return }
        messages[index].status = status
    }
}
