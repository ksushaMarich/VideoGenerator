
import SwiftUI

struct PageIndicator: View {
    let count: Int
    let selection: Int

    private let activeWidth: CGFloat = 25
    private let dotSize: CGFloat = 8
    private let spacing: CGFloat = 7

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(
                        index == selection
                        ? AnyShapeStyle(
                            LinearGradient(
                                colors: [
                                    Color.loaderBlue,
                                    Color.loaderPink
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        : AnyShapeStyle(Color.white.opacity(0.28))
                    )
                    .frame(
                        width: index == selection ? activeWidth : dotSize,
                        height: dotSize
                    )
                    .animation(
                        .spring(response: 1, dampingFraction: 1),
                        value: selection
                    )
            }
        }
    }
}


