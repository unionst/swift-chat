import SwiftChat
import SwiftUI

struct TintedDemo: View {
    @State private var conversation = Conversation(
        messages: SampleThreads.oneToOne,
        partner: People.ben,
        replies: SampleThreads.replies
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatBubbleStyle(Color.pink.gradient)
            .tint(.pink)
            .chatInputPlaceholder("Message")
            .chatHeader {
                BenHeader()
            }
    }
}

#Preview {
    NavigationStack {
        TintedDemo()
    }
}
