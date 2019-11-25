import UIKit

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
        - completion: (() -> Void)? action when user dismisses the alert
        - cancellable: Bool adds a cancel button which makes sure the completion is not called, defaults to false

    */
    func alert(title: String,
               message: String = "",
               completion: (() -> Void)? = nil,
               cancellable: Bool = false) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("button_ok", comment: ""), style: .default, handler: { [completion] _ in completion?() })
        alertController.addAction(OKAction)
        if cancellable {
            let cancelAction = UIAlertAction(title: NSLocalizedString("button_cancel", comment: ""), style: .cancel)
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }

    /**
    Presents an alert

    - parameters:
        - title: String
        - message: String default = ""
        - completion: (() -> Void)? action when user dismisses the alert
        - cancellable: Bool adds a cancel button which makes sure the completion is not called, defaults to false
        - okButtonTitle: String defaults to NSLocalizedString("button_ok", comment: "")
        - cancelButtonTitle: String defaults to NSLocalizedString("button_cancel", comment: "")

    */
    func alert(title: String,
               message: String = "",
               completion: (() -> Void)? = nil,
               cancellable: Bool = false,
               okButtonTitle: String = NSLocalizedString("button_ok", comment: ""),
               cancelButtonTitle: String = NSLocalizedString("button_cancel", comment: "")) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [completion] _ in completion?() })
        alertController.addAction(OKAction)
        if cancellable {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel)
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }

    /**
    Presents an alert

    - parameters:
        - title: String
        - message: String default = ""
        - okAction: (() -> Void)? action when user dismisses the alert
        - cancelAction: (() -> Void)? action when user cancels the alert
        - okButtonTitle: String defaults to NSLocalizedString("button_ok", comment: "")
        - cancelButtonTitle: String defaults to NSLocalizedString("button_cancel", comment: "")

    */
    func alert(title: String,
               message: String = "",
               okAction: (() -> Void)? = nil,
               cancelAction: (() -> Void)? = nil,
               okButtonTitle: String = NSLocalizedString("button_ok", comment: ""),
               cancelButtonTitle: String = NSLocalizedString("button_cancel", comment: "")) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [okAction] _ in okAction?() })
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { [cancelAction] _ in cancelAction?() })
        alertController.addAction(cancelAction)
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
