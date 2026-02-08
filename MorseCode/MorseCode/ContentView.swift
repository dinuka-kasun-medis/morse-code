import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TrainerViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Morse Code Trainer")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color("Accent"))
                        .padding(.top, 16)

                    Text(viewModel.currentLetter)
                        .font(.system(size: 110, weight: .bold, design: .rounded))
                        .foregroundColor(Color("AccentDark"))
                        .frame(minHeight: 140)

                    Text(viewModel.displayInput)
                        .font(.system(size: 44, weight: .semibold, design: .monospaced))
                        .foregroundColor(.black.opacity(0.8))
                        .frame(minHeight: 70)
                        .tracking(8)

                    MorseKeyView(
                        isActive: viewModel.isPressing,
                        onPressBegan: { viewModel.pressBegan() },
                        onPressEnded: { duration in viewModel.pressEnded(duration: duration) }
                    )

                    if let feedback = viewModel.feedback {
                        Text(feedback.text)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(feedback.isCorrect ? Color("Success") : Color("Error"))
                            .frame(minHeight: 40)
                    } else {
                        Text(" ")
                            .frame(minHeight: 40)
                    }

                    InstructionsView()

                    StatsView(correct: viewModel.correctCount,
                              attempts: viewModel.attemptCount,
                              accuracy: viewModel.accuracy)

                    Button(action: viewModel.resetGame) {
                        Text("New Letter")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(12)
                    }

                    MorseReferenceView()
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .onAppear { viewModel.start() }
    }
}

private struct InstructionsView: View {
    var body: some View {
        Text("How to play:\nTap the key for a dot (·) and press longer for a dash (—).\nPause briefly after each letter to submit.")
            .font(.system(size: 15, weight: .regular))
            .multilineTextAlignment(.center)
            .foregroundColor(Color.black.opacity(0.65))
    }
}

private struct StatsView: View {
    let correct: Int
    let attempts: Int
    let accuracy: Int

    var body: some View {
        HStack {
            StatItem(label: "Correct", value: "\(correct)")
            StatItem(label: "Attempts", value: "\(attempts)")
            StatItem(label: "Accuracy", value: "\(accuracy)%")
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color("Card"))
        .cornerRadius(12)
    }
}

private struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.black.opacity(0.6))
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("Accent"))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MorseReferenceView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Morse Code Reference")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("Accent"))

            Text(MorseAlphabet.referenceText)
                .font(.system(size: 13, weight: .regular, design: .monospaced))
                .foregroundColor(Color.black.opacity(0.65))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("Card"))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
