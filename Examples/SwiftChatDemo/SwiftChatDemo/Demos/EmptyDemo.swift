import SwiftChat
import SwiftUI

struct EmptyDemo: View {
    @State private var conversation = Conversation(
        partner: People.alex,
        replies: SampleThreads.replies
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatEmptyView {
                ContentUnavailableView(
                    "No messages yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Say hello to Alex. They’ll write back.")
                )
            }
            .chatInputPlaceholder("Message")
            .chatHeader {
                ChatHeader(title: "Alex", avatarURL: People.alexAvatar)
            }
    }
}

#Preview {
    NavigationStack {
        EmptyDemo()
    }
}
