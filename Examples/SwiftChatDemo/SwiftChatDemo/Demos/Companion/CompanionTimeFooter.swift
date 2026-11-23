import SwiftUI

struct CompanionTimeFooter: View {
    let date: Date
    let isFromMe: Bool
    let avatarSize: Double

    var body: some View {
        Text(date, format: .dateTime.hour().minute())
            .font(.caption2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: isFromMe ? .trailing : .leading)
            .padding(isFromMe ? .trailing : .leading, avatarSize + 11)
            .padding(.top, 4)
            .padding(.bottom, 8)
    }
}
