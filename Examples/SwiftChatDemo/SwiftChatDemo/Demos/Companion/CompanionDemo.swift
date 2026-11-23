import SwiftChat
import SwiftUI
import UIKit

struct CompanionDemo: View {
    @State private var thread = CompanionThread()
    @State private var showsStickers = false

    private static let avatarSize = 48.0

    var body: some View {
        Chat(thread.messages) { message in
            let row = Message(message.text, role: message.role, timestamp: message.sentAt)
                .messageFooter {
                    if message.showsTime {
                        CompanionTimeFooter(date: message.sentAt, isFromMe: message.role == .me, avatarSize: Self.avatarSize)
                    }
                }
            if message.steps.isEmpty {
                row
            } else {
                row.messageHeader {
                    CompanionStepsHeader(steps: message.steps)
                }
            }
        }
        .chatSenderInfo(.always)
        .chatAvatar { role in
            CompanionAvatar(role: role, size: Self.avatarSize)
        }
        .chatAvatarLayout(size: Self.avatarSize, edge: .top, showsOwnAvatar: true)
        .chatIncomingBubbleStyle(.white.opacity(0.72))
        .chatBubbleShape { bubble in
            UnevenRoundedRectangle(
                topLeadingRadius: bubble.isFromMe ? 20 : 6,
                bottomLeadingRadius: 20,
                bottomTrailingRadius: 20,
                topTrailingRadius: bubble.isFromMe ? 6 : 20,
                style: .continuous
            )
        }
        .chatInputCapabilities([.photoLibrary, .camera, .files])
        .chatAttachmentActions([
            ChatAttachmentAction(id: "location", title: "Location", systemImage: "mappin.and.ellipse", tint: .green) {
                thread.send("📍 The dog park on Union Street")
            },
            ChatAttachmentAction(id: "music", title: "Music", systemImage: "music.note", tint: .pink) {
                thread.send("🎵 Walking playlist")
            },
            ChatAttachmentAction(id: "gift", title: "Gift", systemImage: "gift.fill", tint: .orange) {
                thread.send("🎁 A new tennis ball")
            }
        ])
        .chatAttachmentMenuStyle(.grid)
        .chatInputPanel(isPresented: $showsStickers) {
            Image(systemName: "face.smiling")
        } content: {
            CompanionStickerPanel { sticker in
                thread.send(sticker)
            }
        }
        .chatInputPlaceholder("Say something")
        .chatMessageContextMenu { [thread] (id: UUID) in
            [
                ChatContextMenuItem("Copy", systemImage: "doc.on.doc") {
                    UIPasteboard.general.string = thread.text(of: id)
                }
            ]
        }
        .chatHeader {
            ChatHeader(title: "Gavin") {
                CompanionAvatar(role: CompanionMessage.gavin, size: 60)
            }
        }
        .onChatSend { text, _ in
            guard let text else { return }
            await thread.send(text)
        }
        .background {
            CompanionBackdrop()
        }
    }
}

#Preview {
    NavigationStack {
        CompanionDemo()
    }
}
