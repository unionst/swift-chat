import SwiftChat
import SwiftUI

struct EmptyDemo: View {
    @State private var conversation = Conversation(
        partner: People.ben,
        replies: SampleThreads.replies
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatEmptyView {
                ContentUnavailableView(
                    "No messages yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Say hello to Ben. He’ll write back.")
                )
            }
            .chatInputPlaceholder("Message")
            .chatHeader {
                BenHeader()
            }
    }
}

#Preview {
    NavigationStack {
        EmptyDemo()
    }
}
