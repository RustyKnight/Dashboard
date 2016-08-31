import UIKit


public extension UIColor {
    public func blend(with color: UIColor) -> UIColor {
        return UIColor.blend(self, with: color, by: 0.5)
    }

    public func blend(with color: UIColor, by ratio: Double) -> UIColor {
        return UIColor.blend(self, with: color, by: ratio)
    }

    public class func blend(_ color: UIColor, with: UIColor, by ratio: Double) -> UIColor {
        let inverseRatio: CGFloat = 1.0 - ratio.toCGFloat

        let fromComponents = color.cgColor.components
        let toComponents = with.cgColor.components

        var red = (toComponents?[0])! * ratio.toCGFloat + (fromComponents?[0])! * inverseRatio
        var green = (toComponents?[1])! * ratio.toCGFloat + (fromComponents?[1])! * inverseRatio
        var blue = (toComponents?[2])! * ratio.toCGFloat + (fromComponents?[2])! * inverseRatio
        var alpha = with.cgColor.alpha * ratio.toCGFloat +
            color.cgColor.alpha * inverseRatio

        red = max(0.0, min(1.0, red))
        green = max(0.0, min(1.0, green))
        blue = max(0.0, min(1.0, blue))
        alpha = max(0.0, min(1.0, alpha))

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    public func darken(by: Double) -> UIColor {
        let rgb = cgColor.components

        let red = max(0, ((rgb?[0])! - (1.0.toCGFloat) * by.toCGFloat))
        let green = max(0, ((rgb?[1])! - (1.0.toCGFloat) * by.toCGFloat))
        let blue = max(0, ((rgb?[2])! - (1.0.toCGFloat) * by.toCGFloat))
        let alpha = cgColor.alpha

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    public func brighten(by:Double) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
//        var w: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        let red = min(1.0, r + (1.0.toCGFloat * by.toCGFloat))
        let green = min(1.0, g + (1.0.toCGFloat * by.toCGFloat))
        let blue = min(1.0, b + (1.0.toCGFloat * by.toCGFloat))
        let alpha = cgColor.alpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

//    func brighten(by percent: Double) -> UIColor {
//        return withBrightness(ofFactor: CGFloat(1 + percent))
//    }
//
//    /**
//     Returns a darker color by the provided percentage
//
//     :param: darking percent percentage
//     :returns: darker UIColor
//     */
//    func darken(by percent: Double) -> UIColor {
//        return withBrightness(ofFactor: CGFloat(1 - percent))
//    }

    /**
     Return a modified color using the brightness factor provided

     :param: factor brightness factor
     :returns: modified color
     */
    func withBrightness(ofFactor factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
    public func with(alpha: Double) -> UIColor {
        let rgb = cgColor.components
        return UIColor(red: rgb![0], green: rgb![0], blue: rgb![0], alpha: alpha.toCGFloat)
    }

    public func invert() -> UIColor {
        let rgb = cgColor.components
        let alpha = cgColor.alpha
        return UIColor(red: 1.0 - rgb![0], green: 1.0 - rgb![0], blue: 1.0 - rgb![0], alpha: alpha)
    }
}

//public extension Float {
//    public var toCGFloat: CGFloat {
//        return CGFloat(self)
//    }
//}
//
//public extension Double {
//    public var toCGFloat: CGFloat {
//        return CGFloat(self)
//    }
//}
//
//public extension CGFloat {
//    
//    public var toDouble: Double {
//        return Double(self)
//    }
//    
//    public var toFloat: Float {
//        return Float(self)
//    }
//}
//
