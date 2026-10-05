import SwiftChat
import SwiftUI
import UIKit

struct AgentDemo: View {
    @State private var assistant = Assistant()

    var body: some View {
        Chat(assistant.messages, typingUsers: assistant.thinking ? [Assistant.role] : []) { message in
            if let result = message.result {
                Message(message.text, role: message.role, timestamp: message.sentAt)
                    .messageAttachment {
                        ResultCard(value: result, caption: message.resultCaption ?? "")
                    }
            } else {
                Message(message.text, role: message.role, timestamp: message.sentAt)
                    .messageMedia(message.media)
            }
        }
        .chatStyle(.assistant)
        .chatTypingStatus(assistant.status)
        .chatInputPlaceholder("Ask anything")
        .chatInputCapabilities([.camera, .photoLibrary, .files])
        .chatMessageContextMenu { [assistant] (id: UUID) in
            var items: [ChatContextMenuItem] = []
            if let text = assistant.text(of: id), !text.isEmpty {
                items.append(ChatContextMenuItem("Copy", systemImage: "doc.on.doc") {
                    UIPasteboard.general.string = text
                })
                items.append(ChatContextMenuItem("Regenerate", systemImage: "arrow.clockwise") { })
            }
            return items
        }
        .chatEmptyView {
            ContentUnavailableView(
                "Ask anything",
                systemImage: "sparkles",
                description: Text("Try “square root of 69”, “show me a photo”, or “describe the revolutionary war”.")
            )
        }
        .onChatSend { [assistant] text, media in
            await assistant.send(text, media)
        }
        .navigationTitle("Assistant")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New chat", systemImage: "square.and.pencil") { assistant.reset() }
            }
        }
    }
}

struct ResultCard: View {
    let value: String
    let caption: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.55))
                Text(value)
                    .font(.system(size: 44, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
            }
            Spacer()
            Button {
                UIPasteboard.general.string = value
            } label: {
                Image(systemName: "doc.on.doc.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.18), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? .secondarySystemBackground : .black }), in: RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    NavigationStack {
        AgentDemo()
    }
}
