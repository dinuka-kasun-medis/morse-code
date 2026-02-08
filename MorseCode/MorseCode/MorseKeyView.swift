import SwiftUI

struct MorseKeyView: View {
    let isActive: Bool
    let onPressBegan: () -> Void
    let onPressEnded: (TimeInterval) -> Void

    @State private var pressStart: Date?

    var body: some View {
        VStack(spacing: 8) {
            Text("KEY")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.black.opacity(0.6))

            RoundedRectangle(cornerRadius: 12)
                .fill(isActive ? Color("Accent") : Color("KeyInactive"))
                .frame(height: 70)
                .overlay(
                    Text(isActive ? "—" : "·")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(isActive ? .white : Color.black.opacity(0.6))
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if pressStart == nil {
                                pressStart = Date()
                                onPressBegan()
                            }
                        }
                        .onEnded { _ in
                            guard let start = pressStart else { return }
                            let duration = Date().timeIntervalSince(start)
                            pressStart = nil
                            onPressEnded(duration)
                        }
                )

            Text("Tap for dot (·). Press longer for dash (—).")
                .font(.system(size: 13))
                .foregroundColor(Color.black.opacity(0.55))
        }
    }
}
