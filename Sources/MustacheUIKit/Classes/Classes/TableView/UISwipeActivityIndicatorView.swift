
import Foundation
import UIKit
import SnapKit

open class UISwipeActivityIndicatorView: UIActivityIndicatorView {

	var buttonLabel: UIView!

	init(buttonLabel: UIView){
		super.init(style: .whiteLarge)
		self.buttonLabel = buttonLabel
	}

	required public init(coder: NSCoder) {
		super.init(coder: coder)
	}

	override open func startAnimating() {
		super.startAnimating()
		self.buttonLabel.alpha = 0
	}

    override  open func stopAnimating() {
		super.stopAnimating()
		self.buttonLabel.alpha = 1
	}

}

extension UIView {

    func addActivityIndicatorView(color: UIColor = .white) -> UISwipeActivityIndicatorView? {

        if NSStringFromClass(type(of: self)) == "UISwipeActionStandardButton",
           let label = self.subviews.first(where: { NSStringFromClass(type(of: $0)) == "UIButtonLabel" }),
           let superview = label.superview {
            let activityIndicator = UISwipeActivityIndicatorView(buttonLabel: label)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = color
            superview.addSubviews(activityIndicator)
            activityIndicator.snp.makeConstraints { (maker: ConstraintMaker) in
                maker.left.equalTo(superview).inset(10)
                maker.centerY.equalTo(superview)
            }
            return activityIndicator
        } else {
            return nil
        }
    }

}
