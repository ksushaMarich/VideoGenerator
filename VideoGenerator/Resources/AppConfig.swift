import Foundation

enum AppConfig {
    static let appId = ""
    static let apphudToken = "app_FmCjFTwjWpcLSafxT8vCDeVffJyfFS"

    enum Links {
        static let privacyPolicy = ""
        static let termsOfUse = ""
        static let supportForm = ""
        static let shareApp = "https://apps.apple.com/app/id\(AppConfig.appId)"
        static let review = "https://apps.apple.com/app/id\(AppConfig.appId)?action=write-review"
    }
}
