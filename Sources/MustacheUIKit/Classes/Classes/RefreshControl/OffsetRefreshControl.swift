
open class OffsetRefreshControl: UIRefreshControl {

    public var offset: CGFloat = 100

    override open var frame: CGRect {
        set {
            var rect = newValue
            rect.origin.y += offset
            super.frame = rect
        }
        get {
            return super.frame
        }
    }

}
