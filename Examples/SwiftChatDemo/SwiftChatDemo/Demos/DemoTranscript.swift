import SwiftChat
import SwiftUI

struct DemoTranscript: View {
    let conversation: Conversation

    var body: some View {
        Chat(conversation.messages) { message in
            Message(message.text, role: message.role, timestamp: message.sentAt)
                .messageStatus(message.status)
                .messageMedia(message.media)
                .messageReactions(message.reactions)
        }
        .chatTypingIndicators(conversation.typing)
        .chatAvatar { role in
            PersonAvatar(role: role)
        }
        .chatMessageContextMenu { [conversation] (id: UUID) in
            MessageMenu.items(for: id, in: conversation)
        }
        .onChatSend { [conversation] text, media in
            await conversation.send(text, media)
        }
    }
}
