import UIKit

open class TabBarController: UITabBarController {

    var orgFrameView: CGRect?

    var movedFrameView: CGRect?

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let movedFrameView = self.movedFrameView {
            self.view.frame = movedFrameView
        }
    }

    open func setTabBarVisible(visible: Bool, animated: Bool) {
        //since iOS11 we have to set the background colour to the bar color it seams the navbar seams to get smaller during animation; this visually hides the top empty space...
        self.view.backgroundColor = self.tabBar.barTintColor
        // bail if the current state matches the desired state
        if (self.tabBarIsVisible() == visible) { return }

        //we should show it
        if visible {
            self.tabBar.isHidden = false
            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                //restore form or frames
                self.view.frame = self.orgFrameView!
                //errase the stored locations so that...
                self.orgFrameView = nil
                self.movedFrameView = nil
                //...the layoutIfNeeded() does not move them again!
                self.view.layoutIfNeeded()
            }
        }
        //we should hide it
        else {
            //safe org positions
            self.orgFrameView = self.view.frame
            // get a frame calculation ready
            let offsetY = self.tabBar.frame.size.height
            self.movedFrameView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            //animate
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.view.frame = self.movedFrameView!
                self.view.layoutIfNeeded()
            }) {
                (_) in
                self.tabBar.isHidden = true
            }
        }
    }

    open func tabBarIsVisible() -> Bool {
        return self.orgFrameView == nil
    }
}
