import Foundation
import UIKit

public extension UIScrollView {
    var currentPage:Int {
        return Int((self.contentOffset.x + (0.5 * self.frame.size.width)) / self.frame.width)
    }
}
