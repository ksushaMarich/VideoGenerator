
import SwiftUI

struct LoadingBar: View {
    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.loaderBlue,
                                Color.loaderPink
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * progress
                    )
            }
        }
        .frame(height: 4)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                progress = 1
            }
        }
    }
}

