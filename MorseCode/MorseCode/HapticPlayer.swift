import UIKit

final class HapticPlayer {
    enum Strength {
        case light
        case medium
    }

    func impact(strength: Strength) {
        let style: UIImpactFeedbackGenerator.FeedbackStyle = (strength == .light) ? .light : .medium
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
