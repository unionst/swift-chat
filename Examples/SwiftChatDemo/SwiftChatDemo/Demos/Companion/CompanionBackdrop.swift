import SwiftUI

struct CompanionBackdrop: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 0.74, green: 0.86, blue: 0.97), Color(red: 0.95, green: 0.97, blue: 1), Color(red: 0.82, green: 0.9, blue: 0.98)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
