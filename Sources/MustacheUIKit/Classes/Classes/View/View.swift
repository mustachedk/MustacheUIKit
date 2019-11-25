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
        // self.clipsToBounds = self.layer.cornerRadius > 0
    }
    
    @IBInspectable
    open var cornerUL: Bool = false { //UpperLeft
        didSet { self.updateCorners() }
    }

    @IBInspectable
    open var cornerUR: Bool = false { //UpperRight
        didSet { self.updateCorners() }
    }

    @IBInspectable
    open var cornerLL: Bool = false { //LowerLeft
        didSet { self.updateCorners() }
    }

    @IBInspectable
    open var cornerLR: Bool = false { //LowerRight
        didSet { self.updateCorners() }
    }

    fileprivate func updateCorners() {
        var corners: CACornerMask = CACornerMask(rawValue: 0)
        if self.cornerUL { corners.insert(.layerMinXMinYCorner) }
        if self.cornerUR { corners.insert(.layerMaxXMinYCorner) }
        if self.cornerLL { corners.insert(.layerMinXMaxYCorner) }
        if self.cornerLR { corners.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = corners
    }

    // ----------------------------- Shadow -----------------------------//

    @IBInspectable
    open var hasShadow: Bool = false

    @IBInspectable
    open var sketchColor: UIColor = .black

    @IBInspectable
    open var sketchAlpha: Float = 0.5

    @IBInspectable
    open var sketchX: CGFloat = 0

    @IBInspectable
    open var sketchY: CGFloat = 0

    @IBInspectable
    open var sketchBlur: CGFloat = 0

    @IBInspectable
    open var sketchSpread: CGFloat = 0

    fileprivate func configureShadow() {

        if !self.hasShadow { return }

        self.layer.shadowColor = self.sketchColor.cgColor
        self.layer.shadowOpacity = self.sketchAlpha
        self.layer.shadowOffset = CGSize(width: self.sketchX, height: self.sketchY)
        self.layer.shadowRadius = self.sketchBlur / 2.0
        if self.sketchSpread == 0 {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        } else {
            let dx = -self.sketchSpread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
        }

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
