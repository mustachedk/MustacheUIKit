import UIKit

@IBDesignable
open class TextField: UITextField {

    open var toolbarLoading: Bool {
        set {
            if newValue { self.toolbarStartLoading() } else { self.toolbarStopLoading() }
            self.nextSibling?.toolbarLoading = newValue
        }
        get { return self.loadingIndicator?.isAnimating ?? false }
    }

    open var isDoneHidden: Bool {
        set {
            self.doneButton?.isEnabled = !newValue
            self.doneButton?.tintColor = newValue ? .clear : nil
            self.doneButton?.width = newValue ? 0.01 : 0
            self.nextSibling?.isDoneHidden = newValue
        }
        get { return self.doneButton!.isEnabled }
    }

    fileprivate func toolbarStartLoading() {
        if let toolbar = (self.inputAccessoryView as? UIToolbar),
           var items = toolbar.items,
           let loading = self.loadingButton,
           let loadingView = (loading.customView as? UIActivityIndicatorView) {
            items.remove(at: 5)
            items.insert(loading, at: 5)
            loadingView.startAnimating()
            toolbar.items = items
        }
    }

    fileprivate func toolbarStopLoading() {
        if let toolbar = (self.inputAccessoryView as? UIToolbar),
           var items = toolbar.items,
           let loading = self.loadingButton,
           let loadingView = (loading.customView as? UIActivityIndicatorView),
           let done = self.doneButton {
            loadingView.stopAnimating()
            items.remove(at: 5)
            items.insert(done, at: 5)
            toolbar.items = items
        }
    }

    fileprivate var previousButton: UIBarButtonItem? { return (self.inputAccessoryView as? UIToolbar)?.items?[0] }
    fileprivate var nextButton: UIBarButtonItem? { return (self.inputAccessoryView as? UIToolbar)?.items?[2] }

    fileprivate var loadingIndicator: UIActivityIndicatorView? { return self.loadingButton?.customView as? UIActivityIndicatorView }
    fileprivate var dismissButton: UIBarButtonItem? { return (self.inputAccessoryView as? UIToolbar)?.items?.last }

    @discardableResult
    open func addAccessoryView(doneText: String, dismissText: String, previousImage: UIImage, nextImage: UIImage, textColor: UIColor = .white, backgroundColor: UIColor = .gray) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))

        let previousButton = UIBarButtonItem(image: previousImage, style: .plain, target: self, action: #selector(handlePrevious))
        previousButton.isEnabled = self.previousSibling != nil

        let spacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer1.width = 19

        let nextButton = UIBarButtonItem(image: nextImage, style: .plain, target: self, action: #selector(handleNext))
        nextButton.isEnabled = self.nextSibling != nil

        let spacer2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let placeholder = UIBarButtonItem(title: self.placeholder, style: .done, target: self, action: nil)
        placeholder.isEnabled = false
        let spacer3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        self.doneButton = UIBarButtonItem(title: NSLocalizedString(doneText, comment: ""), style: .done, target: self, action: #selector(handleDone))

        let loadingIndicator = UIActivityIndicatorView(style: .white)
        self.loadingButton = UIBarButtonItem(customView: loadingIndicator)

        let dismiss = UIBarButtonItem(title: NSLocalizedString(dismissText, comment: ""), style: .done, target: self, action: #selector(handleDismiss))
        toolBar.items = [previousButton, spacer1, nextButton, spacer2, placeholder, spacer3, self.doneButton!, dismiss]
        toolBar.tintColor = textColor
        toolBar.barTintColor = backgroundColor

        self.inputAccessoryView = toolBar

        return toolBar
    }

    // ------------------------- Next/Previous responder ------------------------- //

    open var previousAction: Action? {
        didSet {
            self.previousButton?.isEnabled = self.previousAction != nil || self.previousSibling != nil
        }
    }

    fileprivate var previousSibling: TextField?

    @objc
    fileprivate func handlePrevious() {
        self.previousAction?()
        self.previousSibling?.becomeFirstResponder()
    }

    open var nextAction: Action? {
        didSet {
            self.nextButton?.isEnabled = self.nextAction != nil || self.nextSibling != nil
        }
    }

    @IBOutlet
    open var nextSibling: TextField? {
        didSet {

            self.nextSibling?.previousSibling = nextSibling != nil ? self : nil
            self.nextSibling?.previousButton?.isEnabled = nextSibling != nil ? true : false

            self.nextButton?.isEnabled = nextSibling != nil
        }
    }

    @objc
    fileprivate func handleNext() {
        self.nextAction?()
        self.nextSibling?.becomeFirstResponder()
    }

    // ------------------------- Buttons ------------------------- //

    open var doneButton: UIBarButtonItem?

    @objc
    fileprivate func handleDone() {
        self.doneAction?()
    }

    open var loadingButton: UIBarButtonItem?

    // ------------------------- Actions ------------------------- //

    public typealias Action = (() -> Void)

    open var doneAction: Action? {
        didSet {
            if doneAction != nil {
                self.doneButton?.isEnabled = true
                self.doneButton?.tintColor = nil
            } else {
                self.doneButton?.isEnabled = false
                self.doneButton?.tintColor = .clear
            }
        }
    }

    open var dismissAction: Action?

    @objc
    fileprivate func handleDismiss() {
        if let dismiss = self.dismissAction {
            dismiss()
        } else {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }

    override init(frame: CGRect) { super.init(frame: frame) }

    public required init?(coder: NSCoder) { super.init(coder: coder) }
}
