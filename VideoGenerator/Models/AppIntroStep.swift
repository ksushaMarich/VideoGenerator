enum AppIntroStep: Int, CaseIterable {
    case first
    case second
    case paywall

    var title: String {
        switch self {
            case .first:
                return "Ask AI anything"
            case .second:
                return "Turn photos into videos"
            case .paywall:
                return ""
        }
    }

    var subtitle: String {
        switch self {
            case .first:
                return "Answers, emails, ideas and plans in seconds"
            case .second:
                return "Pick a template — AI animates your photo"
            case .paywall:
                return ""
        }
    }
}
