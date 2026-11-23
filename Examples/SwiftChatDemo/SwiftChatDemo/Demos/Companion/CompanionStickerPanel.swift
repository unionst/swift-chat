import SwiftUI

struct CompanionStickerPanel: View {
    let send: (String) -> Void

    private static let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    private static let stickers = ["🐶", "🦴", "🎾", "❤️", "🌤️", "🌳", "☕️", "🥐", "😴", "🛁", "✨", "🎁"]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Self.columns, spacing: 12) {
                ForEach(Self.stickers, id: \.self) { sticker in
                    Button {
                        send(sticker)
                    } label: {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                Text(sticker)
                                    .font(.largeTitle)
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(sticker)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 28)
        }
    }
}
