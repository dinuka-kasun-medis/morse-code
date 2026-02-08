import Foundation

enum MorseAlphabet {
    static let map: [String: String] = [
        "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".", "F": "..-.",
        "G": "--.", "H": "....", "I": "..", "J": ".---", "K": "-.-", "L": ".-..",
        "M": "--", "N": "-.", "O": "---", "P": ".--.", "Q": "--.-", "R": ".-.",
        "S": "...", "T": "-", "U": "..-", "V": "...-", "W": ".--", "X": "-..-",
        "Y": "-.--", "Z": "--.."
    ]

    static func randomLetter() -> String {
        let letters = Array(map.keys).sorted()
        return letters.randomElement() ?? "A"
    }

    static func display(for morse: String) -> String {
        morse
            .replacingOccurrences(of: ".", with: "·")
            .replacingOccurrences(of: "-", with: "—")
    }

    static let referenceText: String =
        "A: ·— | B: —··· | C: —·—· | D: —·· | E: · | F: ··—· | G: ——· | H: ···· | I: ·· | J: ·——— | K: —·— | L: ·—·· | M: —— | N: —· | O: ——— | P: ·——· | Q: ——·— | R: ·—· | S: ··· | T: — | U: ··— | V: ···— | W: ·—— | X: —··— | Y: —·—— | Z: ——··"
}
