import Foundation
import SwiftChat

enum SampleThreads {
    static var oneToOne: [DemoMessage] {
        [
            DemoMessage(text: "Did the new chat UI ever ship?", role: .me, sentAt: ago(1500)),
            DemoMessage(text: "Shipped it this morning", role: People.ben, sentAt: ago(1480)),
            DemoMessage(
                text: "It’s a single SwiftUI view now",
                role: People.ben,
                sentAt: ago(1475),
                reactions: [reaction("❤️", mine: true)]
            ),
            DemoMessage(text: "No way. The tails and everything?", role: .me, sentAt: ago(1320)),
            DemoMessage(text: "Tails, typing dots, the drag-to-dismiss keyboard", role: People.ben, sentAt: ago(900)),
            DemoMessage(text: "Even the springy scroll when you fling the list", role: People.ben, sentAt: ago(890)),
            DemoMessage(text: "How long did that take?", role: .me, sentAt: ago(600)),
            DemoMessage(
                text: "Longer than I’ll admit",
                role: People.ben,
                sentAt: ago(420),
                reactions: [reaction("😂", mine: true)]
            ),
            DemoMessage(text: "Worth it though", role: .me, sentAt: ago(120)),
            DemoMessage(
                text: "This feels just like Messages",
                role: .me,
                sentAt: ago(110),
                reactions: [reaction("👍", from: People.ben)]
            ),
            DemoMessage(text: "Press and hold any bubble to react or copy", role: People.ben, sentAt: ago(8)),
        ]
    }

    static var replies: [String] {
        [
            "Okay, that send animation is smooth",
            "Try dragging the keyboard down from the messages",
            "And fling the list, the bubbles have weight",
            "I could do this all day",
        ]
    }

    static var group: [DemoMessage] {
        [
            DemoMessage(text: "Welcome to the team chat!", role: .system, sentAt: ago(1500)),
            DemoMessage(text: "Hey everyone", role: People.ben, sentAt: ago(1200)),
            DemoMessage(text: "Glad to be here", role: People.sam, sentAt: ago(1140)),
            DemoMessage(text: "Once there are three of us, avatars show up on their own", role: .me, sentAt: ago(600)),
            DemoMessage(
                text: "And each name sits right above the bubble",
                role: .me,
                sentAt: ago(580),
                reactions: [reaction("👍", from: People.ben), reaction("❤️", from: People.alex)]
            ),
            DemoMessage(text: "Slick", role: People.alex, sentAt: ago(120)),
            DemoMessage(text: "Same rules as Messages", role: People.sam, sentAt: ago(20)),
        ]
    }

    static var longThread: [DemoMessage] {
        thread(from: beats, endingAt: .now)
    }

    static var attachments: [DemoMessage] {
        [
            DemoMessage(text: "How was the hike?", role: People.ben, sentAt: ago(900)),
            DemoMessage(
                text: "Made it to the top",
                role: .me,
                sentAt: ago(840),
                media: [photo(1018, width: 1200, height: 800)]
            ),
            DemoMessage(
                role: People.ben,
                sentAt: ago(600),
                media: [photo(1036, width: 800, height: 1000)]
            ),
            DemoMessage(text: "A few more from the way down", role: .me, sentAt: ago(420)),
            DemoMessage(
                role: .me,
                sentAt: ago(415),
                media: [
                    photo(1015, width: 1200, height: 800),
                    photo(1039, width: 800, height: 1000),
                    photo(1043, width: 1200, height: 800),
                ]
            ),
            DemoMessage(text: "Tap the plus to send your own photos and files", role: People.ben, sentAt: ago(60)),
        ]
    }

    static func olderPage(before date: Date) -> [DemoMessage] {
        thread(from: beats, endingAt: date.addingTimeInterval(-3600))
    }

    private static let beats: [(text: String, mine: Bool)] = [
        ("Morning! Did you see the new build?", false),
        ("Just opened it", true),
        ("The scrolling feels different", true),
        ("Different how?", false),
        ("The bubbles have weight now", true),
        ("They lag a little and settle when you fling", true),
        ("That’s the springy layout", false),
        ("Every cell is hung off its own spring", false),
        ("So the ones near your thumb keep up", true),
        ("And the far ones catch up a beat later", true),
        ("Exactly", false),
        ("Honestly I didn’t expect to notice it", true),
        ("But now I can’t unsee it", true),
        ("Same with the keyboard", false),
        ("Drag it down and the list tracks your finger", false),
        ("Wait, it does that too?", true),
        ("Try it. Pull down from the messages", false),
        ("Okay that’s ridiculous", true),
        ("How much of this is UIKit underneath?", true),
        ("All of the hard parts", false),
        ("It’s a collection view wearing a SwiftUI coat", false),
        ("Makes sense", true),
        ("Scroll up, there’s hours of this", false),
        ("I’m scrolling", true),
        ("Feels great the whole way", true),
        ("That’s the point", false),
    ]

    private static func thread(from beats: [(text: String, mine: Bool)], endingAt end: Date) -> [DemoMessage] {
        beats.enumerated().map { index, beat in
            DemoMessage(
                text: beat.text,
                role: beat.mine ? .me : People.ben,
                sentAt: end.addingTimeInterval(-Double(beats.count - index) * 45)
            )
        }
    }

    private static func ago(_ seconds: TimeInterval) -> Date {
        Date.now.addingTimeInterval(-seconds)
    }

    private static func reaction(_ emoji: String, mine: Bool) -> ChatReaction {
        ChatReaction(emoji: emoji, people: [ChatReaction.Person(id: "me", name: "You")], isMine: mine)
    }

    private static func reaction(_ emoji: String, from role: ChatRole) -> ChatReaction {
        ChatReaction(
            emoji: emoji,
            people: [ChatReaction.Person(id: People.name(of: role).lowercased(), name: People.name(of: role))],
            isMine: false
        )
    }

    private static func photo(_ id: Int, width: Int, height: Int) -> MessageMedia {
        .image(
            url: URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!,
            width: width,
            height: height
        )
    }
}
