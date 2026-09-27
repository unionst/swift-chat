import SwiftChat
import SwiftUI

struct AttachmentsDemo: View {
    @State private var conversation = Conversation(messages: SampleThreads.attachments)

    var body: some View {
        DemoTranscript(conversation: conversation)
            .chatInputPlaceholder("Message")
            .chatInputCapabilities([.photoLibrary, .files])
            .chatHeader {
                ChatHeader(title: "Alex", avatarURL: People.alexAvatar)
            }
    }
}

#Preview {
    NavigationStack {
        AttachmentsDemo()
    }
}
