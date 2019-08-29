import UIKit

// fixing Bug in XCode
// http://openradar.appspot.com/18448072
extension UIImageView {

    convenience init(string: String, font: UIFont, color: UIColor) {
        self.init(image: UILabel(string: string, font: font, color: color).snapshot())
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.tintColorDidChange()
    }
}
