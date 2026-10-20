

import Foundation
import SwiftUI
import StoreKit
import ApphudSDK
import Combine

@MainActor
final class PurchaseManager: ObservableObject {

    static let shared = PurchaseManager()

    // MARK: - Manual testing

    @Published var useManualSubscription = false
    @Published var manualSubscriptionValue = true

    @AppStorage("hasSeenOnBoarding")
    var hasSeenOnBoarding = false

    // MARK: - State

    @Published private(set) var paywall: ApphudPaywall?
    @Published private(set) var products: [ApphudProduct] = []
    @Published private(set) var subscriptionOptions: [SubscriptionOption] = []

    @Published private(set) var apphudIsSubscribed = false
    @Published private(set) var isLoading = false
    @Published private(set) var isPurchasing = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasPaywallConfiguration = false
    @Published private(set) var didStartInitialization = false
    @Published private(set) var cachedConfiguration: PaywallConfiguration?

    var isSubscribed: Bool {
        useManualSubscription
            ? manualSubscriptionValue
            : apphudIsSubscribed
    }

    private init() {
        Apphud.start(apiKey: AppConfig.apphudToken)
        initialize()
    }

    // MARK: - Initialization

    func initialize() {
        guard !didStartInitialization else { return }

        didStartInitialization = true

        if let cached = PaywallConfigurationStorage.loadCache() {
            cachedConfiguration = cached
            hasPaywallConfiguration = true
        } else if let fallback = PaywallConfigurationStorage.loadFallback() {
            cachedConfiguration = fallback
            hasPaywallConfiguration = true
        }

        refreshSubscriptionStatus()
        loadPaywall()
    }

    // MARK: - Paywall

    func loadPaywall() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task {
            defer { isLoading = false }

            let loadedPaywall = await Apphud.paywall("main")

            guard let loadedPaywall else { return }

            paywall = loadedPaywall
            products = loadedPaywall.products

            await loadSubscriptionOptions(from: loadedPaywall.products)

            let configuration = PaywallConfiguration(
                paywallID: loadedPaywall.identifier,
                productIDs: loadedPaywall.products.map(\.productId),
                savedAt: Date()
            )

            PaywallConfigurationStorage.save(configuration)
            cachedConfiguration = configuration
            hasPaywallConfiguration = true        }
    }

    // MARK: - StoreKit products

    private func loadSubscriptionOptions(
        from apphudProducts: [ApphudProduct]
    ) async {
        var storeProducts: [(apphud: ApphudProduct, store: Product)] = []

        for apphudProduct in apphudProducts {
            do {
                // В SDK 3.1.3 product() — async throwing method.
                guard let storeProduct = try await apphudProduct.product() else { continue }

                storeProducts.append(
                    (apphud: apphudProduct, store: storeProduct)
                )
            } catch {
                print(
                    "Failed to load StoreKit product " +
                    "\(apphudProduct.productId): \(error.localizedDescription)"
                )
            }
        }

        subscriptionOptions = SubscriptionOptionBuilder.build(
            from: storeProducts
        )
    }

    // MARK: - Subscription status

    func refreshSubscriptionStatus() {
        apphudIsSubscribed = Apphud.hasPremiumAccess()
        print("Subscription active: \(apphudIsSubscribed)")
    }

    // MARK: - Purchase

    func makePurchase(id: String,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard let product = products.first(where: { $0.productId == id}) else { return }
        if useManualSubscription {
            manualSubscriptionValue = true
            completion?(true)
            return
        }

        guard !isPurchasing else { return }

        isPurchasing = true
        errorMessage = nil

        Apphud.purchase(product) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }

                self.isPurchasing = false

                if let error = result.error {
                    self.errorMessage = error.localizedDescription
                    completion?(false)
                    return
                }

                self.refreshSubscriptionStatus()
                completion?(self.apphudIsSubscribed)
            }
        }
    }

    // MARK: - Restore purchases

    func restorePurchases(
        completion: ((Bool) -> Void)? = nil
    ) {
        if useManualSubscription {
            completion?(manualSubscriptionValue)
            return
        }

        errorMessage = nil

        Apphud.restorePurchases { [weak self] _, _, error in
            Task { @MainActor in
                guard let self else { return }

                if let error {
                    self.errorMessage = error.localizedDescription
                    completion?(false)
                    return
                }

                self.refreshSubscriptionStatus()
                completion?(self.apphudIsSubscribed)
            }
        }
    }
}
