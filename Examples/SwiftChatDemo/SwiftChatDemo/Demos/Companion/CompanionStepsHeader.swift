import SwiftUI

struct CompanionStepsHeader: View {
    let steps: [CompanionStep]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(steps, id: \.self) { step in
                Label(step.title, systemImage: step.systemImage)
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}
