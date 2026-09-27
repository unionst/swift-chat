import SwiftUI

struct DemoRow: View {
    let demo: Demo

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(demo.title)
                    .font(.headline)
                Text(demo.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: demo.systemImage)
        }
        .padding(.vertical, 4)
    }
}
