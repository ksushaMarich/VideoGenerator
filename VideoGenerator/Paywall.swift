
import ApphudSDK
import Foundation

func loadPaywall() {
    Task {
        let paywall = await Apphud.paywall("main")

        guard let paywall else {
            print("Paywall 'main' not found")
            return
        }

        Apphud.paywallShown(paywall)

        print("Paywall loaded:", paywall.identifier)
        print("Products count:", paywall.products.count)
    }
}
