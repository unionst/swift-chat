import Foundation
import Observation
import SwiftChat

@MainActor @Observable
final class CompanionThread {
    private(set) var messages = CompanionMessage.opening

    private var replies = [
        "Got it. On my way.",
        "The one on the corner has shade until noon.",
        "I’ll bring the long leash."
    ]

    func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let startsRun = messages.last?.role != .me
        messages.append(CompanionMessage(text: trimmed, role: .me, showsTime: startsRun))

        Task {
            try? await Task.sleep(for: .milliseconds(1600))
            reply()
        }
    }

    func text(of id: UUID) -> String? {
        messages.first { $0.id == id }?.text
    }

    private func reply() {
        guard messages.last?.role == .me else { return }
        let text = replies.removeFirst()
        replies.append(text)
        messages.append(CompanionMessage(text: text, role: CompanionMessage.gavin, steps: [.thought], showsTime: true))
    }
}
