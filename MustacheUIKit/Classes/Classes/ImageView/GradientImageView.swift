import Foundation
import UIKit

public class GradientImageView: UIImageView {

    fileprivate var gradientMask: CAGradientLayer?

    public var colors: [UIColor] = [UIColor.clear, UIColor.black, UIColor.black, UIColor.clear] {
        didSet { self.configure() }
    }

    public var locations: [Double] = [0.0, 0.15, 0.85, 1.0] {
        didSet { self.configure() }
    }

    public var startPoint = CGPoint(x: 0.5, y: 0) {
        didSet { self.configure() }
    }

    public var endPoint = CGPoint(x: 0.5, y: 1) {
        didSet { self.configure() }
    }

    override open var bounds: CGRect {
        didSet { self.gradientMask?.frame = self.bounds }
    }

    override open var frame: CGRect {
        didSet { self.gradientMask?.frame = self.bounds }
    }

    override public init(image: UIImage?) {
        super.init(image: image)
        self.configure()
    }

    override public init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.configure()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    fileprivate func configure() {
        self.gradientMask = CAGradientLayer()
        self.gradientMask?.colors = self.colors.map { $0.cgColor }
        self.gradientMask?.locations = self.locations.map { NSNumber(value: $0) }
        self.gradientMask?.startPoint = self.startPoint
        self.gradientMask?.endPoint = self.endPoint

        self.layer.mask = self.gradientMask

        self.setNeedsLayout()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.gradientMask?.frame = self.bounds
    }
}
