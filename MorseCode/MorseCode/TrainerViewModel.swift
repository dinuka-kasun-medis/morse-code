import Foundation
import SwiftUI
import Combine

final class TrainerViewModel: ObservableObject {
    struct Feedback {
        let text: String
        let isCorrect: Bool
    }

    @Published var currentLetter: String = "A"
    @Published var displayInput: String = ""
    @Published var isPressing: Bool = false
    @Published var feedback: Feedback?
    @Published var correctCount: Int = 0
    @Published var attemptCount: Int = 0

    var accuracy: Int {
        guard attemptCount > 0 else { return 0 }
        return Int(round((Double(correctCount) / Double(attemptCount)) * 100))
    }

    private var userInput: String = ""
    private var submitWorkItem: DispatchWorkItem?
    private let tonePlayer = TonePlayer()
    private let haptics = HapticPlayer()

    func start() {
        resetGame()
    }

    func resetGame() {
        currentLetter = MorseAlphabet.randomLetter()
        userInput = ""
        displayInput = ""
        feedback = nil
        submitWorkItem?.cancel()
        submitWorkItem = nil
    }

    func pressBegan() {
        isPressing = true
        submitWorkItem?.cancel()
        submitWorkItem = nil
    }

    func pressEnded(duration: TimeInterval) {
        isPressing = false
        let symbol = duration > 0.2 ? "-" : "."
        let displaySymbol = symbol == "." ? "·" : "—"
        userInput.append(symbol)
        displayInput.append(displaySymbol)

        let toneDuration = symbol == "." ? 0.1 : 0.3
        tonePlayer.play(duration: toneDuration)
        haptics.impact(strength: symbol == "." ? .light : .medium)

        scheduleSubmit()
    }

    private func scheduleSubmit() {
        submitWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.checkAnswer()
        }
        submitWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }

    private func checkAnswer() {
        guard !userInput.isEmpty else { return }
        attemptCount += 1
        let correctMorse = MorseAlphabet.map[currentLetter] ?? ""

        if userInput == correctMorse {
            correctCount += 1
            feedback = Feedback(text: "✓ Correct! Great job!", isCorrect: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                self?.resetGame()
            }
        } else {
            let readable = MorseAlphabet.display(for: correctMorse)
            feedback = Feedback(text: "✗ Try again! Expected: \(readable)", isCorrect: false)
            userInput = ""
            displayInput = ""
        }
    }
}
