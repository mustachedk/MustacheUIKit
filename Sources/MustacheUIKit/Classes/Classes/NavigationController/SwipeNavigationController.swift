
import Foundation
import UIKit

public final class SwipeNavigationController: UINavigationController {

    // MARK: - Lifecycle

    public var _preferredInterfaceOrientationForPresentation: UIInterfaceOrientation = .portrait
    public var _supportedInterfaceOrientations: UIInterfaceOrientationMask = [.portrait]

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.delegate = self
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // This needs to be in here, not in init
        self.interactivePopGestureRecognizer?.delegate = self
    }

    deinit {
        self.delegate = nil
        self.interactivePopGestureRecognizer?.delegate = nil
    }

    // MARK: - Overrides

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - Private Properties

    fileprivate var duringPushAnimation = false

}

// MARK: - UINavigationControllerDelegate

public extension SwipeNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
    }

    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return self._preferredInterfaceOrientationForPresentation
    }

    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return self._supportedInterfaceOrientations
    }

}

// MARK: - UIGestureRecognizerDelegate

public extension SwipeNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == self.interactivePopGestureRecognizer else { return true } // default value

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return self.viewControllers.count > 1 && self.duringPushAnimation == false
    }
}
