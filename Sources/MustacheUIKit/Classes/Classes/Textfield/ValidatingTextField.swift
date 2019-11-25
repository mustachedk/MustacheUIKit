import UIKit

@IBDesignable
open class ValidatingTextField: TextField {

    let allowedCharactersChar: String = "*"

    @IBInspectable
    open var formattingPattern: String? //Use * instead of allowed characters, fx ****-****-****-****

    @IBInspectable
    open var allowedCharacters: CharacterSet? // fx CharacterSet.decimalDigits

    @IBInspectable
    open var regexPatterns: [String] = [] // fx VISA ^4[0-9]{12}(?:[0-9]{3})?$

    open var containsIllegalCharacters: Bool {
        var containsIllegalCharacters = false
        if let illegalCharacters = self.allowedCharacters?.inverted {
            containsIllegalCharacters = self.safeText.rangeOfCharacter(from: illegalCharacters) != nil
        }
        return containsIllegalCharacters
    }

    open var regExMatch: Bool {
        if self.regexPatterns.count == 0 { return true }
        for pattern in self.regexPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let results = regex.matches(in: self.safeText, range: NSRange(self.safeText.startIndex..., in: self.safeText))
                if results.count > 0 { return true }
            }
        }
        return false
    }

    open var isValid: Bool { return !self.containsIllegalCharacters && self.regExMatch }

    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: self)
    }

    @objc
    func textDidChange() {

        guard let text = self.text, let formattingPattern = self.formattingPattern else { return }

        if text.count > 0 && formattingPattern.count > 0 {

            let maskCharacters: String = formattingPattern.replacingOccurrences(of: allowedCharactersChar, with: "") //---
            let maskedCharacterSet: CharacterSet = CharacterSet(charactersIn: maskCharacters) // -
            let tempString: String = text.components(separatedBy: maskedCharacterSet).joined() //4571123456781234

            var finalText = ""

            var tempIndex = tempString.startIndex
            var formatterIndex = formattingPattern.startIndex

            repeat {

                let tempChar: Character = tempString[tempIndex]
                let formatChar: Character = formattingPattern[formatterIndex]

                if formatChar.unicodeScalars.allSatisfy({ maskedCharacterSet.contains($0) }) {
                    finalText += String(formatChar)
                    formatterIndex = formattingPattern.index(formatterIndex, offsetBy: 1)
                } else {
                    finalText += String(tempChar)

                    tempIndex = tempString.index(tempIndex, offsetBy: 1)
                    formatterIndex = formattingPattern.index(formatterIndex, offsetBy: 1)
                }

            } while formatterIndex < formattingPattern.endIndex && tempIndex < tempString.endIndex

            self.text = finalText
        }
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForNotifications()
    }

}
