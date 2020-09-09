import UIKit

public extension UIImage {

    /**
    Create a 1x1 image with this color

    - returns:
    UIImage

    - parameters:
        - color: UIColor

    */
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /**
    Create a tinted image with this color

    - returns:
    UIImage?

    - parameters:
        - color: UIColor

    */
    func tinted(color: UIColor) -> UIImage? {
        let image = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let tinted = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tinted
    }

    /**
    Rotates the image by the specified degrees

    - returns:
    UIImage

    - parameters:
        - degrees: CGFloat

    */
    func imageRotatedBy(degrees : CGFloat) -> UIImage {
        let maxSize = max(self.size.width, self.size.height)
        let size = CGSize(width: maxSize, height: maxSize)

        UIGraphicsBeginImageContext(size)

        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)

        bitmap.draw(self.cgImage!, in: CGRect(origin: origin, size: size))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /**
    Takes a screenshot of the entire screen

    - returns:
    UIImage

    */
    class func getScreenShot() -> UIImage {
        let view: UIView = UIApplication.shared.keyWindow!
        let snappedView = view.snapshotView(afterScreenUpdates: true)
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        snappedView?.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

public extension UIImage {

    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(tintColor: UIColor) -> UIImage {

        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }

    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(fillColor: UIColor) -> UIImage {

        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            //            context.fillCGContextFillRect(context, rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }

    private func modifiedImage(draw: (CGContext, CGRect) -> Void) -> UIImage {

        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

/* Extension for croping transparent pixels
   example:
   let image: UIImage = UIImage(imageLiteral: "YOUR_IMAGE")
   let uiImageView = UIImageView(image: image.cropImageByAlpha())
   view.addSubview(uiImageView)

   Code was basically done here:
   http://stackoverflow.com/questions/9061800/how-do-i-autocrop-a-uiimage/13922413#13922413
   http://www.markj.net/iphone-uiimage-pixel-color/
 */
public extension UIImage {

    func cropImageByAlpha() -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        guard let context = createARGBBitmapContextFromImage(inImage: cgImage) else { return self }
        let height = cgImage.height
        let width = cgImage.width
        var rect: CGRect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        context.draw(cgImage, in: rect)

        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else { return self }

        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        //Filter through data and look for non-transparent pixels.
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */
                if data[Int(pixelIndex)] != 0 { //Alpha value is not zero pixel is not transparent.
                    if (x < minX) {
                        minX = x
                    }
                    if (x > maxX) {
                        maxX = x
                    }
                    if (y < minY) {
                        minY = y
                    }
                    if (y > maxY) {
                        maxY = y
                    }
                }
            }
        }
        rect = CGRect(x: CGFloat(minX), y: CGFloat(minY), width: CGFloat(maxX - minX), height: CGFloat(maxY - minY))
        let imageScale: CGFloat = self.scale
        guard let cgiImage = cgImage.cropping(to: rect) else { return self }
        return UIImage(cgImage: cgiImage, scale: imageScale, orientation: self.imageOrientation)
    }

    private func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {
        let width = inImage.width
        let height = inImage.height
        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = malloc(bitmapByteCount)
        if bitmapData == nil {
            return nil
        }
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        return context
    }
}

public extension UIImage {

    func withGradient(locations: [CGFloat], colors: [CGColor]) -> UIImage {

        UIGraphicsBeginImageContext(self.size)

        let context = UIGraphicsGetCurrentContext()

        self.draw(at: CGPoint(x: 0, y: 0))

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = locations

        let colors = colors as CFArray

        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)

        let startPoint = CGPoint(x: self.size.width / 2, y: 0)
        let endPoint = CGPoint(x: self.size.width / 2, y: self.size.height)

        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        UIGraphicsEndImageContext()

        return image
    }
}

public extension UIImage {

    var inverted: UIImage {

        guard let inputCGImage = self.cgImage else { return self }

        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return self }

        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else { return self }

        let pixelBuffer: UnsafeMutablePointer<UIImage.RGBA32> = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                let color: RGBA32 = pixelBuffer[offset]
                let alphaComponent = color.alphaComponent
                pixelBuffer[offset] = RGBA32(red: 1, green: 1, blue: 1, alpha: 255 - alphaComponent)
            }
        }

        guard let outputCGImage = context.makeImage() else { return self }
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        return outputImage

    }

    struct RGBA32: Equatable {

        private var color: UInt32

        var redComponent: UInt8 { return UInt8((color >> 24) & 255) }

        var greenComponent: UInt8 { return UInt8((color >> 16) & 255) }

        var blueComponent: UInt8 { return UInt8((color >> 8) & 255) }

        var alphaComponent: UInt8 { return UInt8((color >> 0) & 255) }

        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }

        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

        static public func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }

}
