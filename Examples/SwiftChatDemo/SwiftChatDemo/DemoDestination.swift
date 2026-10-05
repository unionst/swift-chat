import SwiftUI

struct DemoDestination: View {
    let demo: Demo

    var body: some View {
        Group {
            switch demo {
            case .conversation: ConversationDemo()
            case .group: GroupDemo()
            case .history: HistoryDemo()
            case .attachments: AttachmentsDemo()
            case .tinted: TintedDemo()
            case .empty: EmptyDemo()
            case .agent: AgentDemo()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
