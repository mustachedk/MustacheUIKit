import UIKit
import MustacheFoundation

public extension UIViewController {

    /// Is this UIViewController presented modally, dont only count on this variable
    var isModal: Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

    /// Convenience storyboardID for UIViewController
    class var storyboardID: String { return "\(self)" }

    /**
    Presents an alert

    - parameters:
        - title: String
        - message: String default = ""
        - okAction: (() -> Void)? action when user dismisses the alert
        - cancelAction: (() -> Void)? action when user cancels the alert
        - okButtonTitle: String
        - cancelButtonTitle: String

    */
    func alert(title: String,
               message: String = "",
               okAction: (() -> Void)? = nil,
               cancelAction: (() -> Void)? = nil,
               okButtonTitle: String? = nil,
               cancelButtonTitle: String? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let okAction = okAction {
            let OKAction = UIAlertAction(title: okButtonTitle ?? "button_ok".localized, style: .default, handler: { [okAction] _ in okAction() })
            alertController.addAction(OKAction)
        }

        if let cancelAction = cancelAction {
            let cancelAction = UIAlertAction(title: cancelButtonTitle ?? "button_cancel".localized, style: .cancel, handler: { [cancelAction] _ in cancelAction() })
            alertController.addAction(cancelAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }

    /**
    Adds a child view controller and animates it in

    - parameters:
        - child: UIViewController

    */
    func add(child controller: UIViewController) {

        controller.view.alpha = 0

        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)

        UIView.animate(withDuration: 0.3) { () -> Void in
            controller.view.alpha = 1
        }
    }

    /**
    Removes a child view controller and animates it out

    - parameters:
        - child: UIViewController

    */
    func remove(child controller: UIViewController) {

        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            controller.view.alpha = 0
        }, completion: { b in
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        })
    }

    /**
    Removes all child view controllers and animates them out

    */
    func removeChildren() {

        let children = self.children

        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            for child in children {
                child.view.alpha = 0
            }
        }, completion: { b in
            for child in children {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        })
    }

}
