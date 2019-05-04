import UIKit

@IBDesignable
open class GradientView: UIView {

    @IBInspectable open var startColor: UIColor = UIColor.white {
        didSet { self.setNeedsLayout() }
    }

    @IBInspectable open var endColor: UIColor = UIColor.black {
        didSet { self.setNeedsLayout() }
    }

    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet { self.setNeedsLayout() }
    }

    @IBInspectable open var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet { self.setNeedsLayout() }
    }

    override class open var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override open func layoutSubviews() {
        self.backgroundColor = .clear
        (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
        (layer as! CAGradientLayer).startPoint = startPoint
        (layer as! CAGradientLayer).endPoint = endPoint
    }
}
