import UIKit

@IBDesignable
open class TextField: UITextField {

    // ------------------------- Apperance ------------------------- //

    @IBInspectable open var placeholderColor: UIColor = .lightGray

    @IBInspectable open var toolBarTintColor: UIColor? = .black

    @IBInspectable open var toolBarBackgroundColor: UIColor? = .white

    // ------------------------- Previous ------------------------- //

    @IBInspectable open var previousImage: UIImage?

    fileprivate var previousSibling: TextField?

    fileprivate var previousButton: UIBarButtonItem!

    open var previousAction: Action? {
        didSet {
            self.previousButton?.isEnabled = self.previousAction != nil || self.previousSibling != nil
        }
    }

    @objc fileprivate func handlePrevious() {
        self.previousAction?()
        self.previousSibling?.becomeFirstResponder()
    }


    // ------------------------- Next ------------------------- //

    @IBInspectable open var nextImage: UIImage?

    @IBOutlet open var nextSibling: TextField? {
        didSet {
            self.nextSibling?.previousSibling = nextSibling != nil ? self : nil
            self.nextSibling?.previousButton?.isEnabled = nextSibling != nil ? true : false
            self.nextButton?.isEnabled = nextSibling != nil
        }
    }

    fileprivate var nextButton: UIBarButtonItem!

    open var nextAction: Action? {
        didSet {
            self.nextButton?.isEnabled = self.nextAction != nil || self.nextSibling != nil
        }
    }

    @objc fileprivate func handleNext() {
        self.nextAction?()
        self.nextSibling?.becomeFirstResponder()
    }

    // ------------------------- Done ------------------------- //

    @IBInspectable open var doneText: String?

    open var doneButton: UIBarButtonItem!

    open var doneAction: Action? {
        didSet {
            if doneAction != nil {
                self.doneButton?.isEnabled = true
            } else {
                self.doneButton?.isEnabled = false
            }
        }
    }

    @objc fileprivate func handleDone() {
        self.doneAction?()
        self.resignFirstResponder()
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

    // ------------------------- Dismiss ------------------------- //

    @IBInspectable open var dismissText: String?

    fileprivate var dismissButton: UIBarButtonItem!

    open var dismissAction: Action?

    @objc
    fileprivate func handleDismiss() {
        if let dismiss = self.dismissAction {
            dismiss()
        } else {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }

    // ------------------------- Loading ------------------------- //

    open var loadingButton: UIBarButtonItem = UIBarButtonItem(customView: UIActivityIndicatorView(style: .white))

    fileprivate var loadingIndicator: UIActivityIndicatorView { return self.loadingButton.customView as! UIActivityIndicatorView }

    open var toolbarLoading: Bool {
        set {
            if newValue { self.toolbarStartLoading() } else { self.toolbarStopLoading() }
            self.nextSibling?.toolbarLoading = newValue
            self.previousSibling?.toolbarLoading = newValue
        }
        get { return self.loadingIndicator.isAnimating }
    }

    fileprivate func toolbarStartLoading() {
        var items = self.toolBar.items
        items?.remove(at: 7)
        items?.insert(self.loadingButton, at: 7)
        self.loadingIndicator.startAnimating()
        self.toolBar.items = items
    }

    fileprivate func toolbarStopLoading() {
        var items = self.toolBar.items
        items?.remove(at: 7)
        items?.insert(self.doneButton, at: 7)
        self.loadingIndicator.stopAnimating()
        self.toolBar.items = items
    }

    // ------------------------- Lifecycle ------------------------- //

    fileprivate var toolBar: UIToolbar { return self.inputAccessoryView as! UIToolbar }

    public typealias Action = (() -> Void)

    @discardableResult
    open func addAccessoryView(previousImage: UIImage? = nil, nextImage: UIImage? = nil, doneText: String?, dismissText: String?, textColor: UIColor? = .black, backgroundColor: UIColor? = .white) -> UIToolbar {

        var items: [UIBarButtonItem] = []
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))

        let previousImage = self.previousImage ?? UIImage(named: "navigation_back")!
        self.previousButton = UIBarButtonItem(image: previousImage, style: .plain, target: self, action: #selector(handlePrevious))
        self.previousButton.isEnabled = self.previousAction != nil || self.previousSibling != nil
        self.previousButton.tintColor = textColor
        items.append(self.previousButton)

        let spacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer1.width = 10
        items.append(spacer1)

        let nextImage = self.nextImage ?? UIImage(named: "navigation_forward")!
        self.nextButton = UIBarButtonItem(image: nextImage, style: .plain, target: self, action: #selector(handleNext))
        self.nextButton.isEnabled = self.nextAction != nil || self.nextSibling != nil
        self.nextButton.tintColor = textColor
        items.append(self.nextButton)

        let spacer2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        items.append(spacer2)
        let placeholder = UIBarButtonItem(title: self.placeholder, style: .done, target: self, action: nil)
        placeholder.isEnabled = false
        items.append(placeholder)
        let spacer3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        items.append(spacer3)

        self.doneButton = UIBarButtonItem(title: NSLocalizedString(doneText ?? "OK", comment: ""), style: .done, target: self, action: #selector(handleDone))
        items.append(self.doneButton)

        if let dismissText = dismissText {
            self.dismissButton = UIBarButtonItem(title: NSLocalizedString(dismissText, comment: ""), style: .done, target: self, action: #selector(handleDismiss))
            items.append(self.dismissButton)
        }

        toolBar.items = items
        toolBar.tintColor = textColor
        toolBar.barTintColor = backgroundColor

        self.inputAccessoryView = toolBar

        return toolBar
    }

    override init(frame: CGRect) { super.init(frame: frame) }

    public required init?(coder: NSCoder) { super.init(coder: coder) }

    override open func layoutSubviews(){
      super.layoutSubviews()
      self.configurePlaceHolder()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.addAccessoryView(previousImage: self.previousImage, nextImage: self.nextImage, doneText: self.doneText, dismissText: self.dismissText, textColor: self.toolBarTintColor, backgroundColor: self.toolBarBackgroundColor)
    }

    fileprivate func configurePlaceHolder(){
      guard let currentAttributedString = self.attributedPlaceholder else { return }
      let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: self.placeholderColor]
      self.attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
    }
}
