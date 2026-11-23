import SwiftChat
import SwiftUI

struct CompanionAvatar: View {
    let role: ChatRole
    let size: Double

    private var isMe: Bool {
        role == .me
    }

    var body: some View {
        Circle()
            .fill(isMe ? AnyShapeStyle(Color.orange.gradient) : AnyShapeStyle(Color.indigo.gradient))
            .overlay {
                Image(systemName: isMe ? "sun.max.fill" : "dog.fill")
                    .font(.system(size: size * 0.46, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: size, height: size)
            .accessibilityLabel(isMe ? "You" : "Gavin")
    }
}
