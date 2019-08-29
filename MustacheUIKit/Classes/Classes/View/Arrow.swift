//
// Created by Tommy Hinrichsen on 2019-05-06.
//

import Foundation
import UIKit

public class Arrow: UIView {

    public enum Direction {
        case up, down, left, right
    }

    public var direction: Direction = Direction.right {
        didSet { self.review() }
    }

    public var lineColor = UIColor.red {
        didSet { self.review() }
    }

    public var lineWidth: CGFloat = 3 {
        didSet { self.review() }
    }

    public func review() {
        self.setNeedsDisplay()
    }

    public static func directionToRadians(_ direction: Arrow.Direction) -> CGFloat {
        switch direction {
            case .up:
                return Arrow.degreesToRadians(90)
            case .down:
                return Arrow.degreesToRadians(-90)
            case .left:
                return Arrow.degreesToRadians(0)
            case .right:
                return Arrow.degreesToRadians(180)
        }
    }

    public static func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180
    }

    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.round
        path.move(to: CGPoint(x: self.frame.width / 4 * 3, y: 0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height / 2))
        path.addLine(to: CGPoint(x: self.frame.width / 4 * 3, y: self.frame.height))

        let arrowLayer = CAShapeLayer()
        arrowLayer.strokeColor = self.lineColor.cgColor
        arrowLayer.lineWidth = self.lineWidth
        arrowLayer.path = path.cgPath
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.lineJoin = CAShapeLayerLineJoin.round
        arrowLayer.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(arrowLayer)

        self.backgroundColor = UIColor.clear
        self.transform = CGAffineTransform(rotationAngle: Arrow.directionToRadians(self.direction))
    }
}
