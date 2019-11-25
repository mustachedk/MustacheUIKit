//
//  Font.swift
//  MustacheUIKit
//
//  Created by Tommy Hinrichsen on 16/04/2019.
//

import Foundation
import UIKit

public protocol Font {
    var font: UIFont { get }
    var size: CGFloat { get }
}

public extension Font {

    var font: UIFont {
        return UIFont(name: "\(self.fontFamilyName)-\(self.caseName)", size: self.size)!
    }

    var fontFamilyName: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }

    var caseName: String {
        let caseName = Mirror(reflecting: self).children.first?.label ?? String(describing: self)
        let first = String(caseName.prefix(1)).capitalized
        let rest = String(caseName.dropFirst())
        return first + rest
    }
}

public enum SFProDisplay: Font {

    case black(CGFloat)
    case bold(CGFloat)
    case medium(CGFloat)
    case regular(CGFloat)

    public var size: CGFloat {
        switch self {
        case .black(let size), .bold(let size), .medium(let size), .regular(let size):
            return size
        }
    }
}

public enum SFProText: Font {

    case bold(CGFloat)
    case medium(CGFloat)
    case regular(CGFloat)
    case semiBold(CGFloat)

    public var size: CGFloat {
        switch self {
        case .bold(let size), .medium(let size), .regular(let size), .semiBold(let size):
            return size
        }
    }
}

public enum EncodeSans: Font {

    case semiBold(CGFloat)
    case regular(CGFloat)

    public var size: CGFloat {
        switch self {
        case .semiBold(let size), .regular(let size):
            return size
        }
    }
}
