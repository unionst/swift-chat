import Foundation

enum CompanionStep: String, Hashable {
    case thought
    case tool

    var title: String {
        switch self {
        case .thought: "Thought for a moment"
        case .tool: "Searched nearby places"
        }
    }

    var systemImage: String {
        switch self {
        case .thought: "clock.arrow.circlepath"
        case .tool: "wrench.and.screwdriver"
        }
    }
}
