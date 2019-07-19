import UIKit

// fixing Bug in XCode
// http://openradar.appspot.com/18448072
extension UIImageView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.tintColorDidChange()
    }
}
