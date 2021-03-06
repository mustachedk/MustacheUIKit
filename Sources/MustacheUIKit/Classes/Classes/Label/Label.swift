import UIKit

open class Label: UILabel {

    // ----------------------------- Rounded -----------------------------//

    @IBInspectable
    open var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
        get { return self.layer.cornerRadius }
    }

    fileprivate func configureRadius() {

        let radius = self.cornerRadius > 0 ? self.cornerRadius : 0

        self.layer.cornerRadius = radius

        if !self.hasShadow { self.layer.masksToBounds = true }
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

    fileprivate var shadowLayer = CAShapeLayer()

    fileprivate func configureShadow() {

        if !self.hasShadow { return }

        let radius = self.cornerRadius > 0 ? self.cornerRadius : 0

        self.shadowLayer.fillColor = self.backgroundColor?.cgColor
        self.shadowLayer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.shadowLayer.shadowOpacity = 0.2
        self.shadowLayer.shadowRadius = 4

        self.layer.insertSublayer(shadowLayer, at: 0)

        self.shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        self.shadowLayer.shadowPath = shadowLayer.path

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

    override init(frame: CGRect) { super.init(frame: frame) }

    public required init?(coder: NSCoder) { super.init(coder: coder) }
}
