import UIKit
//Xib
public extension UIView {

    /**
    Convenience method for configuring Xib views,

    - returns:
    UIView?

    `@IBOutlet var contentView: UIView!`

    Create an outlet in the swift file called *contentView and bind it to main view of the Xib file.
    Make sure to call `self.contentView = self.configureNibView()` in all constructors


    */
    func configureNibView() -> UIView? {
        guard let nibView = loadViewFromNib() else { return nil }

        self.addSubview(nibView)

        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        return nibView
    }

    /**
    Convenience method for configuring Xib views,

    - returns:
    UIView?

    Used with `func configureNibView()`

    */
    func loadViewFromNib() -> UIView? {
        let nibName = type(of: self).nibName
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let objects = nib.instantiate(withOwner: self, options: nil)
        let view = objects.first as? UIView
        return view
    }

    /// Convenience nibName for UIView
    class var nibName: String {
        return String(describing: self)
    }
}

//Hierarchy
public extension UIView {

    /**
    Convenience method for addind multiple subviews in one line

    - parameters:
        - views: UIView...

    */
    func addSubviews(_ views: UIView...) {
        views.forEach { view in self.addSubview(view) }
    }

    /// Top view in the hierarchy
    var rootView: UIView {
        if let view = self.superview {
            return view.rootView
        } else {
            return self
        }
    }

    /**
    This is a function to get subViews of a view of a particular type

    - returns:
    [T]

    - parameters:
        - type: T.Type

    */
    func subViews<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T {
                all.append(aView)
            }
        }
        return all
    }

    /**
    This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T

    - returns:
    [T]

    - parameters:
        - type: T.Type

    */
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()

        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }

        getSubview(view: self)
        return all
    }

    /**
    This is a function to get a UIViewController of a particular type from view recursively. It would look in the responder chain and return back the UIViewController of the type T

    - returns:
    T?

    */
    func parentViewController<T: UIViewController>() -> T? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? T {
                return viewController
            }
        }
        return nil
    }
}

//Autolayout
public extension UIView {

    /// safeInsets
    var safeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }

}

//Animations
public extension UIView {

    /**
    Convenience method for shake feedback on a view, useful for when the user has entered incorrect data

    - parameters:
        - completion: ((Bool) -> Void)?

    */
    func shake(completion: ((Bool) -> Void)? = nil) {

        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)

        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform.identity },
                       completion: completion)
    }

    /**
    Convenience method for rotating a view using CGAffineTransform

    - parameters:
        - degrees: CGFloat

    */
    func rotate(degrees: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi / 180.0))
        }
    }

    /**
    Convenience method for changing the anchor point of a view

    - parameters:
        - anchor: CGPoint

    */
    func set(anchor: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * anchor.x, y: bounds.size.height * anchor.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = anchor
    }

}

//Image
public extension UIView {

    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


public extension UIView {

    func slideMask(to direction: UIRectEdge = .right, hide: Bool, duration: TimeInterval = 0.3) {

        guard [UIRectEdge.left, UIRectEdge.right].contains(direction), duration > 0 else { return }

        if hide {
            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = UIBezierPath(rect: self.bounds).cgPath

            self.layer.mask = maskLayer

            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = maskLayer.path
            if direction == .right {
                animation.toValue = UIBezierPath(rect: self.bounds.offsetBy(dx: self.bounds.width, dy: 0)).cgPath
            } else if direction == .left {
                animation.toValue = UIBezierPath(rect: self.bounds.offsetBy(dx: -self.bounds.width, dy: 0)).cgPath
            }
            animation.duration = duration
            animation.delegate = self
            animation.setValue(hide, forKey: "hide")

            maskLayer.add(animation, forKey: nil)

        } else {

            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor

            if direction == .right {
                maskLayer.path = UIBezierPath(rect: self.bounds.offsetBy(dx: -self.bounds.width, dy: 0)).cgPath
            } else if direction == .left {
                maskLayer.path = UIBezierPath(rect: self.bounds.offsetBy(dx: self.bounds.width, dy: 0)).cgPath
            }

            self.layer.mask = maskLayer
            self.alpha = 1

            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = maskLayer.path
            animation.toValue = UIBezierPath(rect: self.bounds).cgPath
            animation.duration = duration
            animation.delegate = self
            animation.setValue(hide, forKey: "hide")
            maskLayer.add(animation, forKey: nil)

        }

    }

}

extension UIView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animation = anim as? CABasicAnimation, let hide = animation.value(forKey: "hide") as? Bool else { return }

        if hide { self.alpha = 0 }
        self.layer.mask = nil

    }
}