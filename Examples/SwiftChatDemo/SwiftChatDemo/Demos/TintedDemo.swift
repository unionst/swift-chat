import SwiftChat
import SwiftUI

struct TintedDemo: View {
    @State private var conversation = Conversation(
        messages: SampleThreads.oneToOne,
        partner: People.alex,
        replies: SampleThreads.replies
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatBubbleStyle(Color.pink.gradient)
            .chatInputBarTint(Color.pink.opacity(0.15))
            .chatInputPlaceholder("Message")
            .chatHeader {
                ChatHeader(title: "Alex", avatarURL: People.alexAvatar)
            }
    }
}

#Preview {
    NavigationStack {
        TintedDemo()
    }
}
