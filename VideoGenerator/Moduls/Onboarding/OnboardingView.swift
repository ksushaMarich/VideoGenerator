import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.openURL) private var openURL
    @State private var currentStep: AppIntroStep = .first
    @State private var isLoading = false

    var body: some View {
        if currentStep == .paywall {
            PaywallView {
                purchaseManager.hasSeenOnBoarding = true
            }
        } else {
            ZStack {
                switch currentStep {
                case .first:
                    Image(.firstOnb)
                        .resizable()
                        .ignoresSafeArea()
                case .second:
                    Image(.secondOnb)
                        .resizable()
                        .ignoresSafeArea()
                case .paywall:
                    Color.black
                }
                
                VStack(spacing: 20) {
                    infoContainer
                    
                    Spacer()
                    PageIndicator(count: 2, selection: currentStep == .first ? 0 : 1)
                    continueButton
                        .padding(.horizontal, 16)
                }
                .padding(.top, 56)
            }
            .background(.splashBg)
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                        
//                        LottieView(animationName: "bolt", loopMode: .loop)
//                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
    }
    
    private var continueButton: some View {
        Button {
            let allStates = AppIntroStep.allCases
            let currentIndex = allStates.firstIndex(of: currentStep) ?? 0
            
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = allStates[currentIndex + 1]
            }
        } label: {
            Text("Continue")
                .font(InterFont.semiBold.of(size: 16))
                .foregroundStyle(.white)
                .padding(16)
                .frame(maxWidth: .infinity)
        }
        .background(LinearGradient(colors: [Color.loaderBlue, Color.loaderPink], startPoint: .leading, endPoint: .trailing))
        .clipShape(Capsule())
        .contentShape(Capsule())
    }

    
    @ViewBuilder
    private var infoContainer: some View {
        VStack(spacing: 8) {
            Text(currentStep.title)
                .font(InterFont.bold.of(size: 28))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(currentStep.subtitle)
                .font(InterFont.regular.of(size: 16))
                .foregroundColor(Color.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingView()
}
