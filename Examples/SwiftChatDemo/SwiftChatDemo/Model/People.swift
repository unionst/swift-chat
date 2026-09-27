import Foundation
import SwiftChat

enum People {
    static let ben = ChatRole.user(id: "ben", displayName: "Ben")
    static let alex = ChatRole.user(id: "alex", displayName: "Alex")
    static let sam = ChatRole.user(id: "sam", displayName: "Sam")

    static let team = [ben, alex, sam]

    static func name(of role: ChatRole) -> String {
        switch role {
        case .user(let id, let displayName): displayName ?? id
        case .me: "You"
        case .system: ""
        }
    }
}
