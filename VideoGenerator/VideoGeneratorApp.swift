
import SwiftUI
import ApphudSDK
import StoreKit

@main
struct VideoGeneratorApp: App {
    
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if purchaseManager.hasPaywallConfiguration, !isLoading {
                    ContentView()
                        .environmentObject(purchaseManager)
                } else {
                    LaunchScreen()
                        .task {
                            try? await Task.sleep(for: .seconds(1))
                            isLoading = false
                        }
                }
            }
        }
    }
}
