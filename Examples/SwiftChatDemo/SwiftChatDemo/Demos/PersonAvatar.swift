import SwiftChat
import SwiftUI

struct PersonAvatar: View {
    let role: ChatRole
    var size: Double = 32

    var body: some View {
        if role == People.ben {
            Image(.ben)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(.circle)
        } else {
            ChatAvatar(userName: People.name(of: role), size: size)
        }
    }
}
