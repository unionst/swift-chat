import SwiftChat
import SwiftUI

struct HistoryDemo: View {
    @State private var conversation = Conversation(
        messages: SampleThreads.longThread,
        olderPages: 4
    )

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatInputPlaceholder("Message")
            .chatLoadsOlderMessages { [conversation] in
                await conversation.loadOlderPage()
            }
            .chatHeader {
                ChatHeader(title: "Alex", avatarURL: People.alexAvatar)
            }
    }
}

#Preview {
    NavigationStack {
        HistoryDemo()
    }
}
