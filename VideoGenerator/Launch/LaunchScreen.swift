import SwiftUI

private struct _LaunchScreenContent: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { UIStoryboard(name: "LaunchScreen", bundle: nil)
        .instantiateInitialViewController()!
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct LaunchScreen: View {
    var body: some View {
        _LaunchScreenContent()
            .ignoresSafeArea()
            .overlay(alignment: .center) {
                LoadingBar()
                    .padding(.horizontal, 89)
                    .padding(.top, 166)
            }
    }
}

#Preview {
    LaunchScreen()
}
