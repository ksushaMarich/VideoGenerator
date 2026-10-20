
import SwiftUI

struct PaywallFooter: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                guard let url = URL(string: AppConfig.Links.privacyPolicy) else {
                    print("No privacy policy url")
                    return
                }
                openURL(url)
            } label: {
                Text("Privacy Policy")
                    .font(.system(size: 11, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.darkGrayText)
                    .contentShape(.rect)
            }
            Spacer()
            Button {
                purchaseManager.restorePurchases { _ in }
            } label: {
                Text("Restore Purchases")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.darkGrayText)
                    .contentShape(.rect)
            }
            Spacer()
            Button {
                guard let url = URL(string: AppConfig.Links.termsOfUse) else {
                    print("No privacy terms of use")
                    return
                }
                openURL(url)
            } label: {
                Text("Terms of Use")
                    .font(.system(size: 11, weight: .regular))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.darkGrayText)
                    .contentShape(.rect)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
