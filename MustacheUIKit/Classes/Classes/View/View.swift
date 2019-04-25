import UIKit

@IBDesignable
open class View: UIView {

    // ----------------------------- Color -----------------------------//

    @IBInspectable
    public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }

    @IBInspectable
    public var borderColor: UIColor? {
        get { return UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue?.cgColor }
    }

    // ----------------------------- Rounded -----------------------------//

    @IBInspectable
    open var cornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }

    fileprivate func configureRadius() {
        self.clipsToBounds = self.layer.cornerRadius > 0
    }

    @available(iOS 11.0, *)
    @IBInspectable
    open var cornerUL: Bool { //UpperLeft
        set {
            var corners: CACornerMask = CACornerMask(rawValue: 0)
            if newValue { corners = .layerMinXMinYCorner }

            if self.layer.maskedCorners.contains(.layerMaxXMinYCorner) { corners.insert(.layerMaxXMinYCorner) }
            if self.layer.maskedCorners.contains(.layerMinXMaxYCorner) { corners.insert(.layerMinXMaxYCorner) }
            if self.layer.maskedCorners.contains(.layerMaxXMaxYCorner) { corners.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = corners
        }
        get { return self.layer.maskedCorners.contains(.layerMinXMinYCorner) }
    }

    @available(iOS 11.0, *)
    @IBInspectable
    open var cornerUR: Bool { //UpperRight
        set {
            var corners: CACornerMask = CACornerMask(rawValue: 0)
            if newValue { corners = .layerMaxXMinYCorner }
            if self.layer.maskedCorners.contains(.layerMinXMinYCorner) { corners.insert(.layerMinXMinYCorner) }

            if self.layer.maskedCorners.contains(.layerMinXMaxYCorner) { corners.insert(.layerMinXMaxYCorner) }
            if self.layer.maskedCorners.contains(.layerMaxXMaxYCorner) { corners.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = corners
        }
        get { return self.layer.maskedCorners.contains(.layerMaxXMinYCorner) }
    }

    @available(iOS 11.0, *)
    @IBInspectable
    open var cornerLL: Bool { //LowerLeft
        set {
            var corners: CACornerMask = CACornerMask(rawValue: 0)
            if newValue { corners = .layerMinXMaxYCorner }
            if self.layer.maskedCorners.contains(.layerMinXMinYCorner) { corners.insert(.layerMinXMinYCorner) }
            if self.layer.maskedCorners.contains(.layerMaxXMinYCorner) { corners.insert(.layerMaxXMinYCorner) }

            if self.layer.maskedCorners.contains(.layerMaxXMaxYCorner) { corners.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = corners
        }
        get { return self.layer.maskedCorners.contains(.layerMinXMaxYCorner) }
    }

    @available(iOS 11.0, *)
    @IBInspectable
    open var cornerLR: Bool { //LowerRight
        set {
            var corners: CACornerMask = CACornerMask(rawValue: 0)
            if newValue { corners = .layerMaxXMaxYCorner }
            if self.layer.maskedCorners.contains(.layerMinXMinYCorner) { corners.insert(.layerMinXMinYCorner) }
            if self.layer.maskedCorners.contains(.layerMaxXMinYCorner) { corners.insert(.layerMaxXMinYCorner) }
            if self.layer.maskedCorners.contains(.layerMinXMaxYCorner) { corners.insert(.layerMinXMaxYCorner) }
            self.layer.maskedCorners = corners
        }
        get { return self.layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
    }

    // ----------------------------- Shadow -----------------------------//

    @IBInspectable
    open var hasShadow: Bool = false

    fileprivate func configureShadow() {

        if !self.hasShadow { return }

        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false

    }

    // --------------------------- UITapGestureRecognizer -------------------------------//

    fileprivate typealias Action = ((UIView) -> Void)?

    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action?

    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(_ action: ((UIView) -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc
    fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction { action?(self) }
    }

    // ----------------------------------------------------------//

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.configureRadius()
        self.configureShadow()
    }
}
