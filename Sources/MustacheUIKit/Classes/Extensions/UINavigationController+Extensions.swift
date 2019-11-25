import UIKit

public extension UINavigationController {

    var topNavigationController: UINavigationController {
        if let presentedViewController = self.presentedViewController as? UINavigationController {
            return presentedViewController.topNavigationController
        } else {
            return self
        }
    }
}
