import Foundation
import Observation
import SwiftChat

@MainActor @Observable
final class Assistant {
    static let role = ChatRole.user(id: "assistant", displayName: "Assistant")

    var messages: [AssistantMessage] = []
    var thinking = false
    var status: String?

    private var replyTask: Task<Void, Never>?

    func send(_ text: String?, _ media: [MessageMedia]) async {
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty || !media.isEmpty else { return }

        messages.append(AssistantMessage(text: trimmed, role: .me, media: media))
        replyTask?.cancel()
        replyTask = Task { await reply(to: trimmed) }
    }

    func reset() {
        replyTask?.cancel()
        messages = []
        thinking = false
        status = nil
    }

    func text(of id: UUID) -> String? {
        messages.first { $0.id == id }?.text
    }

    enum Step {
        case stream(String)
        case photo(URL, Int, Int)
        case card(String, String)
        case pause(Double)
    }

    private func reply(to prompt: String) async {
        thinking = true
        try? await Task.sleep(for: .seconds(0.9))
        guard !Task.isCancelled else { return }
        status = "Searching"
        try? await Task.sleep(for: .seconds(1.2))
        guard !Task.isCancelled else { return }
        status = "Reviewing results"
        try? await Task.sleep(for: .seconds(1.0))
        guard !Task.isCancelled else { return }
        status = nil
        thinking = false

        for step in Self.script(for: prompt) {
            guard !Task.isCancelled else { return }
            switch step {
            case .stream(let text):
                await stream(text)
            case .photo(let url, let width, let height):
                messages.append(AssistantMessage(text: "", role: Self.role, media: [.image(url: url, width: width, height: height, blurhash: nil)]))
            case .card(let value, let caption):
                messages.append(AssistantMessage(text: "", role: Self.role, result: value, resultCaption: caption))
            case .pause(let seconds):
                try? await Task.sleep(for: .seconds(seconds))
            }
        }
    }

    private func stream(_ text: String) async {
        let reply = AssistantMessage(text: "", role: Self.role)
        messages.append(reply)
        var streamed = ""
        for (index, word) in text.split(separator: " ", omittingEmptySubsequences: false).enumerated() {
            guard !Task.isCancelled else { return }
            streamed += (index == 0 ? "" : " ") + word
            if let position = messages.firstIndex(where: { $0.id == reply.id }) {
                messages[position].text = streamed
            }
            try? await Task.sleep(for: .milliseconds(40))
        }
    }

    private static func script(for prompt: String) -> [Step] {
        let lowered = prompt.lowercased()
        if lowered.contains("square root") || lowered.contains("short") {
            return [
                .stream("The square root of 69 is approximately 8.3066."),
                .card("8.3066", "√69 ≈"),
                .pause(0.5),
                .stream("By the way, I’m an assistant powered by AI and may make mistakes. Always verify important details."),
            ]
        }
        if lowered.contains("photo") || lowered.contains("picture") || lowered.contains("look like") {
            return [
                .stream("Here’s Yosemite Valley at dawn, with El Capitan on the left and Half Dome in the distance."),
                .photo(URL(string: "https://picsum.photos/id/1018/1200/800")!, 1200, 800),
                .pause(0.4),
                .stream("Tap the photo to see it full screen. Source: [Yosemite National Park](https://www.nps.gov/yose)"),
            ]
        }
        return [.stream(markdownAnswer)]
    }

    private static let markdownAnswer = """
    The **American Revolutionary War** (1775–1783) was the conflict in which thirteen of Great Britain’s North American colonies broke away to form the [United States](https://en.wikipedia.org/wiki/United_States). It began at Lexington and Concord and ended with the Treaty of Paris.

    ## Origins of the Conflict

    After the Seven Years’ War, Parliament tried to pay down its debts by taxing the colonies directly:

    - The **Stamp Act** of 1765 taxed printed paper of every kind
    - The **Townshend Acts** of 1767 taxed glass, lead, paint, and tea
    - The **Tea Act** of 1773 led straight to the Boston Tea Party

    ## Key Turning Points

    1. **Saratoga, 1777.** The surrender of Burgoyne’s army convinced France to enter the war.
    2. **Valley Forge, 1777–78.** The Continental Army survived the winter and came out drilled.
    3. **Yorktown, 1781.** Washington and Rochambeau trapped Cornwallis against the French fleet.

    > “These are the times that try men’s souls.” — Thomas Paine, *The American Crisis*

    ### By the numbers

    ```
    Colonies     13
    Years        8
    Battles      ~230
    ```

    ---

    I’m an assistant powered by AI and may make mistakes. Always verify important details.
    """
}

struct AssistantMessage: Identifiable, Hashable {
    let id = UUID()
    var text: String
    let role: ChatRole
    let sentAt = Date.now
    var media: [MessageMedia] = []
    var result: String?
    var resultCaption: String?
}
