
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        Group {
            if purchaseManager.hasSeenOnBoarding {
                Text("Главый экран")
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
