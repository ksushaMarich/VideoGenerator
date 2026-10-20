
enum BenefitsModel:  String, CaseIterable {
    case aiSparkles
    case aiWriting
    case aiSimplify
    case aiTemplates
    
    var title: String {
        switch self {
        case .aiSparkles:
            "Get results in seconds"
        case .aiTemplates:
            "Create content with AI templates"
        case .aiWriting:
            "Turn any text into better writing"
        case .aiSimplify:
            "Simplify complex information"
        }
    }
    
    func getImage() -> ImageResource {
        switch self {
        case .aiSparkles:
                .aiSparkles
        case .aiTemplates:
                .aiTemplates
        case .aiWriting:
                .aiWriting
        case .aiSimplify:
                .aiSimplify
        }
    }
}
