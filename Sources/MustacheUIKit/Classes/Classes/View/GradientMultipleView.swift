
import Foundation
import UIKit

open class GradientMultipleView: UIView {

    open var startPoint: CGPoint =  .init(x: 0, y: 0) {
        didSet { self.setNeedsLayout() }
    }

    open var endPoint: CGPoint =  .init(x: 0, y: 1) {
        didSet { self.setNeedsLayout() }
    }

    open var colors: [UIColor] = [.clear, .clear] {
        didSet { self.setNeedsLayout() }
    }

    open var locations: [Double] = [0, 1] {
        didSet { self.setNeedsLayout() }
    }

    override class open var layerClass: AnyClass { return CAGradientLayer.self }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        (self.layer as! CAGradientLayer).startPoint = self.startPoint
        (self.layer as! CAGradientLayer).endPoint = self.endPoint
        (self.layer as! CAGradientLayer).colors = self.colors.map(\.cgColor)
        (self.layer as! CAGradientLayer).locations = self.locations.map(\.number)
    }
}
