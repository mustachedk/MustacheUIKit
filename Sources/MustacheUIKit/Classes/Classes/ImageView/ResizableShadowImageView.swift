import Foundation
import UIKit

class ResizableShadowImageView: UIImageView {

    fileprivate var shadowView = UIImageView()

    @IBInspectable
    open var sketchColor: UIColor = .black

    @IBInspectable
    open var sketchAlpha: CGFloat = 0.5

    @IBInspectable
    open var sketchX: CGFloat = 0

    @IBInspectable
    open var sketchY: CGFloat = 0

    @IBInspectable
    open var sketchBlur: CGFloat = 0

    override var frame: CGRect {
        didSet { self.configureShadow() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    fileprivate func configure(){
        self.addSubview(self.shadowView)
    }

    fileprivate func configureShadow() {
        defer { UIGraphicsEndImageContext() }
        guard let image = self.image else { return }
        let size = CGSize(width: image.size.width + self.sketchX, height: image.size.height + self.sketchY)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setShadow(offset: CGSize(width: self.sketchX, height: sketchY), blur: self.sketchBlur, color: self.sketchColor.withAlphaComponent(self.sketchAlpha).cgColor)
        image.draw(at: .zero)
        let imageWithShadow = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: image.capInsets, resizingMode: image.resizingMode)
        self.shadowView.image = imageWithShadow
        self.shadowView.frame = self.bounds
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
        self.configureShadow()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureShadow()
    }

}
