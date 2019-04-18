import UIKit

@IBDesignable
open  class GradientView: UIView {

    @IBInspectable open  var startColor: UIColor = UIColor.white
    @IBInspectable open  var endColor: UIColor = UIColor.black

    @IBInspectable open  var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    @IBInspectable open  var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    override class open  var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override open  func layoutSubviews() {
        self.backgroundColor = .clear
        (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
        (layer as! CAGradientLayer).startPoint = startPoint
        (layer as! CAGradientLayer).endPoint = endPoint
    }
}
