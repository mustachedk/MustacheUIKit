import UIKit

@IBDesignable
open class Button: UIButton {

    //----------------------------------- UIColor -----------------------------------//

    public func set(color: UIColor?, for state: UIControl.State) {
        if let color = color {
            let image = UIImage.imageWithColor(color: color)
            self.setBackgroundImage(image, for: state)
        } else {
            self.setBackgroundImage(nil, for: state)
        }
    }

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

    //----------------------------------- UIActivityIndicator -----------------------------------//

    fileprivate var activityIndicator = UIActivityIndicatorView(style: .white)
    public var activityIndicatorStyle: UIActivityIndicatorView.Style {
        get { return self.activityIndicator.style }
        set { self.activityIndicator.style = newValue }
    }

    fileprivate var normalTitle: String?
    fileprivate var highlightedTitle: String?
    fileprivate var disabledTitle: String?
    fileprivate var selectedTitle: String?

    open var isBusy: Bool = false {
        didSet {
            self.isUserInteractionEnabled = !isBusy
            self.imageView?.isHidden = self.isBusy
            self.activityIndicator.tintColor = self.titleLabel?.textColor ?? .black
            self.isBusy ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            if self.isBusy {
                self.normalTitle = self.title(for: .normal)
                self.highlightedTitle = self.title(for: .highlighted)
                self.disabledTitle = self.title(for: .disabled)
                self.selectedTitle = self.title(for: .selected)
                self.setTitle("", for: UIControl.State())
            } else {
                self.setTitle(self.normalTitle, for: .normal)
                self.setTitle(self.highlightedTitle, for: .highlighted)
                self.setTitle(self.disabledTitle, for: .disabled)
                self.setTitle(self.selectedTitle, for: .selected)
            }
        }
    }

    open override func setTitle(_ title: String?, for state: State) {
        super.setTitle(title, for: state)
        switch state {
            case .normal: self.normalTitle = title
            case .highlighted: self.highlightedTitle = title
            case .disabled: self.disabledTitle = title
            case .selected: self.selectedTitle = title
            default:break
        }
    }

    fileprivate func configureBusy() {
        self.activityIndicator.color = self.titleLabel?.textColor
    }

    //----------------------------------- DidTapButton -----------------------------------//

    public typealias DidTapButton = (Button) -> Void
    public var didTouchUpInside: DidTapButton? {
        didSet {
            if didTouchUpInside != nil {
                self.addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            } else {
                self.removeTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            }
        }
    }

    @objc
    fileprivate func didTouchUpInside(sender: UIButton) {
        if let handler = didTouchUpInside {
            handler(self)
        }
    }

    //----------------------------------- init -----------------------------------//

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }

    fileprivate func configureView() {
        self.adjustsImageWhenHighlighted = false
        self.adjustsImageWhenDisabled = false

        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

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
    public var cornerUL: Bool { //UpperLeft
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
    public var cornerUR: Bool { //UpperRight
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
    public var cornerLL: Bool { //LowerLeft
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
    public var cornerLR: Bool { //LowerRight
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
    public var hasShadow: Bool = false

    @IBInspectable
    open var shadowOpacity: Float = 0.2

    @IBInspectable
    open var shadowOffset: CGSize = CGSize(width: 0.0, height: 4.0)

    fileprivate func configureShadow() {

        if !self.hasShadow { return }

        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false

    }

    // ----------------------------- Font -----------------------------//

    @IBInspectable
    public var normalFont: UIFont?

    @IBInspectable
    public var highlightedFont: UIFont?

    @IBInspectable
    public var disabledFont: UIFont?

    @IBInspectable
    public var selectedFont: UIFont?

    public func setFont(_ font: UIFont?, for state: UIControl.State) {
        switch state {
            case .normal:self.normalFont = font
            case .highlighted: self.highlightedFont = font
            case .disabled: self.disabledFont = font
            case .selected: self.selectedFont = font
            default:
                break
        }
    }

    fileprivate func configureFont() {
        switch self.state {
            case .normal: self.titleLabel?.font = self.normalFont ?? self.titleLabel?.font
            case .highlighted: self.titleLabel?.font = self.highlightedFont ?? self.titleLabel?.font
            case .disabled: self.titleLabel?.font = self.disabledFont ?? self.titleLabel?.font
            case .selected: self.titleLabel?.font = self.selectedFont ?? self.titleLabel?.font
            default:
                break
        }
    }

    // ----------------------------- Gradient -----------------------------//

    fileprivate var gradientLayer = CAGradientLayer()

    @IBInspectable open var startColor: UIColor?
    @IBInspectable open var endColor: UIColor?

    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    @IBInspectable open var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    fileprivate func configureGradient() {
        if let start = self.startColor, let end = self.endColor {
            self.gradientLayer.frame = self.bounds
            self.gradientLayer.colors = [start.cgColor, end.cgColor]
            self.gradientLayer.startPoint = startPoint
            self.gradientLayer.endPoint = endPoint
            self.layer.insertSublayer(self.gradientLayer, at: 0)
        }
    }

    // ----------------------------- LifeCycle -----------------------------//

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.configureGradient()
        self.configureFont()
        self.configureRadius()
        self.configureShadow()
        self.configureBusy()
    }
}
