import UIKit

public extension CGFloat {

    /// Convenience Int value
    var int: Int { return Int(self) }

    /// Convenience Double value
    var double: Double { return Double(self) }

    /// Convenience Float value
    var float: Float { return Float(self) }

    /// Convenience NSNumber value
    var number: NSNumber { return NSNumber(value: self.float) }

    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }

    func toDegrees() -> CGFloat {
        return self * 180.0 / .pi
    }
}

public extension String {

    /// Convenience CGFloat value
    var cgfloat: CGFloat { return CGFloat(Double(self)!) }

}
