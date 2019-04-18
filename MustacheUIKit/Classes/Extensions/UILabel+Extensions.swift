import UIKit

public extension UILabel {

    /// The text of the UILabel or an empty text
    var safeText: String { return self.text ?? "" }

    /**
    Animates the font change for a UILabel

    - parameters:
        - font: UIFont
        - duration: TimeInterval
    */
    func animate(font: UIFont, duration: TimeInterval) {

        if self.font.fontName == font.fontName && self.font.pointSize == font.pointSize { return }
        // let oldFrame = frame
        let labelScale = self.font.pointSize / font.pointSize
        self.font = font
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        // let newOrigin = frame.origin
        // frame.origin = oldFrame.origin // only for left aligned text
        // frame.origin = CGPoint(x: oldFrame.origin.x + oldFrame.width - frame.width, y: oldFrame.origin.y) // only for right aligned text
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            //L self.frame.origin = newOrigin
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }

    /// Is the labels text larger than available frame
    var isTruncated: Bool {
        guard let labelText = text else { return false }
        let size = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let string = (labelText as NSString)
        let labelTextSize = string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).size
        return labelTextSize.height > bounds.size.height
    }

    /// The max number of lines this label will be if max lines is set to 0
    var maxLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
        let lines = textSize.height / charSize
        let linesRounded = Int(ceil(lines))
        return linesRounded
    }

}
