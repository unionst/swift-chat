import SwiftChat
import SwiftUI

struct ConversationDemo: View {
    @State private var conversation = Conversation(
        messages: SampleThreads.oneToOne,
        partner: People.ben,
        replies: SampleThreads.replies
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatInputPlaceholder("Message")
            .chatInputCapabilities([.photoLibrary, .files])
            .chatHeader {
                BenHeader()
            }
    }
}

#Preview {
    NavigationStack {
        ConversationDemo()
    }
}
