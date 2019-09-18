import UIKit

/// A ImageView inside a View so that we round the image and still use shadows and etc
@IBDesignable
open class RoundedImageView: View {

    @IBInspectable
    open var image: UIImage? {
        set { self.imageView.image = newValue}
        get { return self.imageView.image }
    }

    public let imageView = UIImageView()

    public init(image: UIImage?) {
        super.init(frame: .zero)
        self.imageView.image = image
        self.configureView()
        self.configureConstraints()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
        self.configureConstraints()
    }

    fileprivate func configureView() {
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
    }

    fileprivate func configureConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.cornerRadius
    }

}
