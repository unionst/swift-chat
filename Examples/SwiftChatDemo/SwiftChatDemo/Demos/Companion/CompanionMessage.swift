import Foundation
import SwiftChat

struct CompanionMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let role: ChatRole
    var sentAt = Date.now
    var steps: [CompanionStep] = []
    var showsTime = false

    static let gavin = ChatRole.user(id: "gavin", displayName: "Gavin")

    static let opening: [CompanionMessage] = [
        CompanionMessage(
            text: "Morning. Walk first, or breakfast?",
            role: gavin,
            sentAt: .now.addingTimeInterval(-7400),
            steps: [.thought],
            showsTime: true
        ),
        CompanionMessage(
            text: "I already checked the weather.",
            role: gavin,
            sentAt: .now.addingTimeInterval(-7380)
        ),
        CompanionMessage(
            text: "Walk first",
            role: .me,
            sentAt: .now.addingTimeInterval(-900),
            showsTime: true
        ),
        CompanionMessage(
            text: "Then somewhere with a patio. I want to sit outside for an hour while you sniff every table leg in the place.",
            role: .me,
            sentAt: .now.addingTimeInterval(-880)
        ),
        CompanionMessage(
            text: "Found three within a mile.",
            role: gavin,
            sentAt: .now.addingTimeInterval(-600),
            steps: [.thought, .tool],
            showsTime: true
        )
    ]
}
