import Foundation
import SwiftChat

enum SampleThreads {
    static var oneToOne: [DemoMessage] {
        [
            DemoMessage(text: "Did the new chat UI ever ship?", role: People.alex, sentAt: ago(1500)),
            DemoMessage(text: "Shipped it this morning", role: .me, sentAt: ago(1480)),
            DemoMessage(text: "It’s a single SwiftUI view now", role: .me, sentAt: ago(1475)),
            DemoMessage(text: "No way. The tails and everything?", role: People.alex, sentAt: ago(1320)),
            DemoMessage(text: "Tails, typing dots, the drag-to-dismiss keyboard", role: .me, sentAt: ago(900)),
            DemoMessage(text: "Even the springy scroll when you fling the list", role: .me, sentAt: ago(890)),
            DemoMessage(text: "How long did that take?", role: People.alex, sentAt: ago(600)),
            DemoMessage(text: "Longer than I’ll admit", role: .me, sentAt: ago(420)),
            DemoMessage(text: "Worth it though", role: People.alex, sentAt: ago(120)),
            DemoMessage(text: "This feels just like Messages", role: People.alex, sentAt: ago(110)),
            DemoMessage(text: "That was the whole idea", role: .me, sentAt: ago(8), status: .read),
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
            DemoMessage(text: "Hey everyone", role: People.alex, sentAt: ago(1200)),
            DemoMessage(text: "Glad to be here", role: People.sam, sentAt: ago(1140)),
            DemoMessage(text: "Once there are three of us, avatars show up on their own", role: .me, sentAt: ago(600)),
            DemoMessage(text: "And each name sits right above the bubble", role: .me, sentAt: ago(580)),
            DemoMessage(text: "Slick", role: People.alex, sentAt: ago(120)),
            DemoMessage(text: "Same rules as Messages", role: People.sam, sentAt: ago(20)),
        ]
    }

    static var longThread: [DemoMessage] {
        thread(from: beats, endingAt: .now)
    }

    static var attachments: [DemoMessage] {
        [
            DemoMessage(text: "How was the hike?", role: People.alex, sentAt: ago(900)),
            DemoMessage(
                text: "Made it to the top",
                role: .me,
                sentAt: ago(840),
                media: [photo(1018, width: 1200, height: 800)]
            ),
            DemoMessage(
                role: People.alex,
                sentAt: ago(600),
                media: [photo(1036, width: 800, height: 1000)]
            ),
            DemoMessage(text: "Meet here after?", role: People.alex, sentAt: ago(420)),
            DemoMessage(
                role: People.alex,
                sentAt: ago(415),
                media: [.location(latitude: 37.8199, longitude: -122.4783, name: "Golden Gate Bridge")]
            ),
            DemoMessage(
                role: .me,
                sentAt: ago(60),
                media: [.poll(question: "Dinner?", options: ["Tacos", "Ramen", "Pizza"], votes: [2, 1, 0])]
            ),
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
                role: beat.mine ? .me : People.alex,
                sentAt: end.addingTimeInterval(-Double(beats.count - index) * 45)
            )
        }
    }

    private static func ago(_ seconds: TimeInterval) -> Date {
        Date.now.addingTimeInterval(-seconds)
    }

    private static func photo(_ id: Int, width: Int, height: Int) -> MessageMedia {
        .image(
            url: URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!,
            width: width,
            height: height
        )
    }
}
