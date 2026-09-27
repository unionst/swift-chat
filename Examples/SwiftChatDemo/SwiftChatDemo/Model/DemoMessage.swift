import Foundation
import SwiftChat

struct DemoMessage: Identifiable, Hashable {
    let id: UUID
    var text: String
    var role: ChatRole
    var sentAt: Date
    var status: ChatDeliveryStatus?
    var media: [MessageMedia]

    init(
        id: UUID = UUID(),
        text: String = "",
        role: ChatRole,
        sentAt: Date = .now,
        status: ChatDeliveryStatus? = nil,
        media: [MessageMedia] = []
    ) {
        self.id = id
        self.text = text
        self.role = role
        self.sentAt = sentAt
        self.status = status
        self.media = media
    }
}
