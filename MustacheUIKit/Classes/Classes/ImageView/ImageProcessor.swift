
import Foundation
import Kingfisher

/// A ImageProcessor that cuts of the surrounding alpha of an UIImage
public struct CropAlphaProcessor: ImageProcessor {

    public let identifier = "dk.mustache.cropalphaprocessor"

    public init() {}

    // Convert input data/image to target image and return it.
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
            case .image(let image):
                return image.cropImageByAlpha()
            case .data(let data):
                guard let image = UIImage(data: data) else { return nil }
                return image.cropImageByAlpha()
        }
    }
}

/// A ImageProcessor that applies a gradient color to and image
public struct GradientProcessor: ImageProcessor {

    var locations: [CGFloat] = [0.0, 0.15, 0.85, 1.0]
    var colors: [CGColor] = [UIColor.lightGray.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.lightGray.cgColor]

    public let identifier = "dk.mustache.cropalphaprocessor"

    public init() {}

    init(locations: [Double], colors: [UIColor]) {
        self.locations = locations.map { $0.cgfloat }
        self.colors = colors.map { $0.cgColor }
    }

    // Convert input data/image to target image and return it.
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
            case .image(let image):
                return image.withGradient(locations: locations, colors: colors)
            case .data(let data):
                guard let image = UIImage(data: data) else { return nil }
                return image.withGradient(locations: locations, colors: colors)
        }
    }
}
