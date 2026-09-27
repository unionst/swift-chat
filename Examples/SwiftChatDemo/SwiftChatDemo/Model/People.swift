import Foundation
import SwiftChat

enum People {
    static let alexAvatar = URL(string: "https://i.pravatar.cc/240?img=12")

    static let alex = ChatRole.user(id: "alex", displayName: "Alex")
    static let sam = ChatRole.user(id: "sam", displayName: "Sam")
}
