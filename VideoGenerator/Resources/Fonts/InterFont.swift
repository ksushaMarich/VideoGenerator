
import UIKit
import SwiftUI

enum InterFont: String {
    
    case bold = "Inter-Bold"
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    
    func of(size: CGFloat) -> Font {
        Font.custom(self.rawValue, size: size)
    }
}
