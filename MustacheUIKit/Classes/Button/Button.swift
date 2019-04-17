//
//  Button.swift
//  MustacheUIKit
//
//  Created by Tommy Hinrichsen on 16/04/2019.
//

import Foundation
import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa

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

    override open var isHighlighted: Bool {
        didSet {
            if self.hasShadow {
                if isHighlighted {
                    self.shadowLayer.fillColor = self.backgroundColor?.withAlphaComponent(0.7).cgColor
                } else {
                    self.shadowLayer.fillColor = (self.backgroundColor?.cgColor) ?? UIColor.clear.cgColor
                }
            }
        }
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
    public var cornerRadius: CGFloat {
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
    }
}

//extension Reactive where Base: Button {
//    /// Bindable sink for `hidden` property.
//    public var isBusy: Binder<Bool> {
//        return Binder(self.base) { view, busy in
//            view.isBusy = busy
//        }
//    }
//}

