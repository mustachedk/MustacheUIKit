import UIKit

public extension UITextField {

    /// The text of the UITextField or an empty text
    var safeText: String { return self.text ?? "" }

    /**
    Adds a toolbar to the UITextField

    - returns:
    UIToolbar

    - parameters:
        - handlePrevious: () -> Void
        - handleNext: () -> Void
        - handleDone: () -> Void
        - handleDismiss: () -> Void

    */
    @available(iOS 11.0, *)
    @discardableResult
    func addToolbar(handlePrevious: (() -> ())? = nil, handleNext: (() -> ())? = nil, handleDone: @escaping (() -> ()), handleDismiss: @escaping (() -> ())) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))

        let previousButton: UIBarButtonItem!
        if let back = UIImage(named: "button_back") {
            previousButton = UIBarButtonItem(image: back, style: .plain, closure: handlePrevious)
            previousButton.isEnabled = handlePrevious != nil
        } else if NSLocalizedString("button_back", comment: "") != "button_back" {
            previousButton = UIBarButtonItem(title: NSLocalizedString("button_back", comment: ""), style: .plain, closure: handlePrevious)
            previousButton.isEnabled = handlePrevious != nil
        } else {
            previousButton = UIBarButtonItem(title: "<", style: .plain, closure: handlePrevious)
            previousButton.isEnabled = handlePrevious != nil
        }


        let spacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer1.width = 19

        let nextButton: UIBarButtonItem!
        if let forward = UIImage(named: "button_next") {
            nextButton = UIBarButtonItem(image: forward, style: .plain, closure: handleNext)
            nextButton.isEnabled = handleNext != nil
        } else if NSLocalizedString("button_next", comment: "") != "button_next" {
            nextButton = UIBarButtonItem(title: NSLocalizedString("button_next", comment: ""), style: .plain, closure: handleNext)
            nextButton.isEnabled = handleNext != nil
        } else {
            nextButton = UIBarButtonItem(title: ">", style: .plain, closure: handleNext)
            nextButton.isEnabled = handleNext != nil
        }

        let spacer2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let placeholder = UIBarButtonItem(title: self.placeholder, style: .done, target: nil, action: nil)
        placeholder.isEnabled = false

        let spacer3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton: UIBarButtonItem!
        if NSLocalizedString("button_done", comment: "") != "button_done" {
            doneButton = UIBarButtonItem(title: NSLocalizedString("button_done", comment: ""), style: .done, closure: handleDone)
        } else {
            doneButton = UIBarButtonItem(title: "OK", style: .plain, closure: handleDone)
        }

        let dismissButton: UIBarButtonItem!
        if NSLocalizedString("button_close", comment: "") != "button_close" {
            dismissButton = UIBarButtonItem(title: NSLocalizedString("button_close", comment: "") , style: .done, closure: handleDismiss)
        } else {
            dismissButton = UIBarButtonItem(title: "X", style: .plain, closure: handleDismiss)
        }

        toolBar.items = [previousButton, spacer1, nextButton, spacer2, placeholder, spacer3, doneButton, dismissButton]
        toolBar.tintColor = .white
        toolBar.barTintColor = UIColor(named: "UIToolbar_barTintColor") ?? .blue

        self.inputAccessoryView = toolBar

        return toolBar
    }

}



