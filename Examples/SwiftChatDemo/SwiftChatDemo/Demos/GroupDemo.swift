import SwiftChat
import SwiftUI

struct GroupDemo: View {
    @State private var conversation = Conversation(messages: SampleThreads.group)

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatInputPlaceholder("Message")
            .chatHeader {
                ChatHeader(title: "Team Chat")
            }
    }
}

#Preview {
    NavigationStack {
        GroupDemo()
    }
}
