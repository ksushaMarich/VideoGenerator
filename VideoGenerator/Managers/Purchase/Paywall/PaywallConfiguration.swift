
import Foundation

struct PaywallConfiguration: Codable {
    let paywallID: String
    let productIDs: [String]
    let savedAt: Date
}

enum PaywallConfigurationStorage {
    private static let cacheKey = "lastSuccessfulPaywallConfiguration"
    private static let fallbackFileName = "apphud_paywalls_fallback"

    static func loadCache() -> PaywallConfiguration? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard
            let data = UserDefaults.standard.data(forKey: cacheKey),
            let configuration = try? decoder.decode(
                PaywallConfiguration.self,
                from: data
            )
        else {
            return nil
        }

        return configuration
    }

    static func loadFallback() -> PaywallConfiguration? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard
            let url = Bundle.main.url(
                forResource: fallbackFileName,
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let configuration = try? decoder.decode(
                PaywallConfiguration.self,
                from: data
            )
        else {
            return nil
        }

        return configuration
    }

    static func save(_ configuration: PaywallConfiguration) {
        guard let data = try? JSONEncoder().encode(configuration) else {
            return
        }

        UserDefaults.standard.set(data, forKey: cacheKey)
    }
}

