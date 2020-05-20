import UIKit

@IBDesignable
open class Button: UIButton {

    //----------------------------------- UIColor -----------------------------------//

    /// Sets a background color using setBackgroundImage by creating an image with the specifed color
    ///
    /// - Parameters:
    ///     - color: Color of the background
    ///     - for: Which state should this background color apply to
    public func set(color: UIColor?, for state: UIControl.State) {
        if let color = color {
            let image = UIImage.imageWithColor(color: color)
            self.setBackgroundImage(image, for: state)
        } else {
            self.setBackgroundImage(nil, for: state)
        }
    }

    /// Border with on the layer
    @IBInspectable
    public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }

    /// Border color on the layer
    @IBInspectable
    public var borderColor: UIColor? {
        get { return UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue?.cgColor }
    }

    //----------------------------------- UIActivityIndicator -----------------------------------//

    fileprivate var activityIndicator = UIActivityIndicatorView(style: .white)

    /// ActivityIndicatorStyle for the button when its busy
    public var activityIndicatorStyle: UIActivityIndicatorView.Style {
        get { return self.activityIndicator.style }
        set { self.activityIndicator.style = newValue }
    }

    fileprivate var normalTitle: String?
    fileprivate var highlightedTitle: String?
    fileprivate var disabledTitle: String?
    fileprivate var selectedTitle: String?
    
    fileprivate var normalImage: UIImage?
    fileprivate var highlightedImage: UIImage?
    fileprivate var disabledImage: UIImage?
    fileprivate var selectedImage: UIImage?

    /// Hides the text and shows an UIActivityIndicatorView spinning when true
    open var isBusy: Bool = false {
        didSet {
            self.isUserInteractionEnabled = !isBusy
            self.activityIndicator.tintColor = self.titleLabel?.textColor ?? .black
            self.isBusy ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            if self.isBusy {
                
                self.normalTitle = self.title(for: .normal)
                self.highlightedTitle = self.title(for: .highlighted)
                self.disabledTitle = self.title(for: .disabled)
                self.selectedTitle = self.title(for: .selected)
                
                self.normalImage = self.image(for: .normal)
                self.highlightedImage = self.image(for: .highlighted)
                self.disabledImage = self.image(for: .disabled)
                self.selectedImage = self.image(for: .selected)
                
                super.setTitle("", for: UIControl.State())
                super.setImage(nil, for: UIControl.State())
                
            } else {
                
                self.setTitle(self.normalTitle, for: .normal)
                self.setTitle(self.highlightedTitle, for: .highlighted)
                self.setTitle(self.disabledTitle, for: .disabled)
                self.setTitle(self.selectedTitle, for: .selected)
                
                self.setImage(self.normalImage, for: .normal)
                self.setImage(self.highlightedImage, for: .highlighted)
                self.setImage(self.disabledImage, for: .disabled)
                self.setImage(self.selectedImage, for: .selected)
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
    
    open override func setImage(_ image: UIImage?, for state: State) {
        super.setImage(image, for: state)
        switch state {
            case .normal: self.normalImage = image
            case .highlighted: self.highlightedImage = image
            case .disabled: self.disabledImage = image
            case .selected: self.selectedImage = image
            default:break
        }
    }

    fileprivate func configureBusy() {
        self.activityIndicator.color = self.titleLabel?.textColor
    }

    //----------------------------------- DidTapButton -----------------------------------//

    public typealias DidTapButton = (Button) -> Void
    /// Closure for reacting to .touchUpInside events
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

    /// Corner radius with on the layer
    @IBInspectable
    open var cornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }

    fileprivate func configureRadius() {
        // self.clipsToBounds = self.layer.cornerRadius > 0
    }

    /// Should the upper left corner be rounded
    @IBInspectable
    open var cornerUL: Bool = false { //UpperLeft
        didSet { self.updateCorners() }
    }

    /// Should the upper right corner be rounded
    @IBInspectable
    open var cornerUR: Bool = false { //UpperRight
        didSet { self.updateCorners() }
    }

    /// Should the lower left corner be rounded
    @IBInspectable
    open var cornerLL: Bool = false { //LowerLeft
        didSet { self.updateCorners() }
    }

    /// Should the lower right corner be rounded
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


    /// Applies shadow the view
    @IBInspectable
    open var hasShadow: Bool = false

    /// Color of shadow, default .black
    @IBInspectable
    open var sketchColor: UIColor = .black

    /// Alpha of shadow as defined in Sketch
    @IBInspectable
    open var sketchAlpha: Float = 0.5

    /// X of shadow as defined in Sketch
    @IBInspectable
    open var sketchX: CGFloat = 0

    /// Y of shadow as defined in Sketch
    @IBInspectable
    open var sketchY: CGFloat = 0

    /// Blur of shadow as defined in Sketch
    @IBInspectable
    open var sketchBlur: CGFloat = 0

    /// Spread of shadow as defined in Sketch
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

    // ----------------------------- Font -----------------------------//

    /// Font for normal state
    @IBInspectable
    public var normalFont: UIFont?

    /// Font for highlighted state
    @IBInspectable
    public var highlightedFont: UIFont?

    /// Font for disabled state
    @IBInspectable
    public var disabledFont: UIFont?

    /// Font for selected state
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

    /// Start color if we want a button with a gradient background
    @IBInspectable open var startColor: UIColor?

    /// End color if we want a button with a gradient background
    @IBInspectable open var endColor: UIColor?

    /// Start point if we want a button with a gradient background
    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)

    /// End point if we want a button with a gradient background
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
