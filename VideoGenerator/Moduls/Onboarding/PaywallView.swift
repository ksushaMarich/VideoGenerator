
import ApphudSDK
import SwiftUI

struct PaywallView: View {
    
    let onDismiss: () -> ()
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var selectedProduct: String?
    @State private var isCrossActive = false
    
    var body: some View {
        ZStack {
            Image(.paywallBg)
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                Image(.paywallIcon)
                    .resizable()
                    .frame(width: 135, height: 92)
                Text("Create anything\nyou want")
                    .font(InterFont.bold.of(size: 34))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                benefits
                    .padding(.top, 32)
                products
                    .padding(.top, 32)
                HStack(spacing: 0) {
                    Image(.historyRestore)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Cancel Anytime")
                        .foregroundStyle(.darkGrayText)
                        .font(.system(size: 12))
                }
                .padding(.vertical, 8)
                .padding(.top, 32)
                unlockButton
                    .padding(.top, 8)
                PaywallFooter()
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .topLeading) {
            if isCrossActive {
                Button {
                    onDismiss()
                } label: {
                    Image(.cross)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .contentShape(Rectangle())
                .padding(16)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isCrossActive)
        .onAppear {
            selectedProduct = purchaseManager.subscriptionOptions.first?.id
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            isCrossActive = true
        }
    }
    
    
    private var benefits: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(BenefitsModel.allCases, id:  \.self) { benefit in
                HStack(spacing: 8) {
                    Image(benefit.getImage())
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text(benefit.title)
                        .font(InterFont.medium.of(size: 16))
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var unlockButton: some View {
        Button {
            guard let selectedProduct else { return }
            purchaseManager.makePurchase(id: selectedProduct)
        } label: {
            Text("Unlock now")
                .font(InterFont.semiBold.of(size: 16))
                .foregroundStyle(.white)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background {
                    LinearGradient(colors: [Color.loaderBlue, Color.loaderPink], startPoint: .leading, endPoint: .trailing)
                }
                .clipShape(Capsule())
        }
        .contentShape(Capsule())
    }
    
    @ViewBuilder
    private var products: some View {
        VStack(spacing: 12) {
            ForEach(purchaseManager.subscriptionOptions, id: \.self) { product in
                let isSelected = selectedProduct == product.id
                Button {
                    selectedProduct = product.id
                } label: {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(product.title) \(product.weeklyPrice) / week")
                                .foregroundStyle(.white)
                            Text(product.fullPrice)
                                .font(InterFont.regular.of(size: 14))
                                .foregroundStyle(.darkGrayText)
                        }
                        Spacer()
                        if let savingsPercent = product.savingsPercent {
                            Text("SAVE \(savingsPercent)%")
                                .font(InterFont.medium.of(size: 14))
                                .foregroundStyle(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .background(isSelected ? LinearGradient(colors: [.loaderBlue, .loaderPink], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.white.opacity(0.3)], startPoint: .bottom, endPoint: .top))
                                .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(LinearGradient(colors: [.loaderBlue, .loaderPink], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                        } else {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        }
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: 24))
            }
        }
    }
}

#Preview {
    PaywallView{}
}
