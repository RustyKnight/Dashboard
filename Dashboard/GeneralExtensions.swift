//
//  General.swift
//  Cioffi
//
//  Created by Shane Whitehead on 3/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// Trims the string of all white space and new line characters
    var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var empty: Bool {
        return trim.characters.count == 0
    }

    var toBool: Bool {
        switch lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return false
        }
    }
    func replace(_ string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}

extension Int {
    var toRadians: Double {
        return Double(self) * M_PI / 180
    }
    var toDegrees: Double {
        return Double(self) * 180 / M_PI
    }
}

extension Double {
    var toRadians: Double {
        return self * M_PI / 180
    }
    var toDegrees: Double {
        return self * 180 / M_PI
    }
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    var toFloat: Float {
        return Float(self)
    }
}

extension CGFloat {
    var toDouble: Double {
        return Double(self)
    }
    var toRadians: CGFloat {
        return CGFloat(toDouble * M_PI / 180)
    }
    var toDegrees: CGFloat {
        return CGFloat(toDouble * 180 / M_PI)
    }
}

extension Float {
    var toDouble: Double {
        return Double(self)
    }
    var toRadians: Float {
        return Float(toDouble * M_PI / 180)
    }
    var toDegrees: Float {
        return Float(toDouble * 180 / M_PI)
    }
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension CGRect {
    func withInsets(_ insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.minX + insets.left,
                      y: self.minY + insets.top,
                      width: self.width - (insets.right + insets.left),
                      height: self.height - (insets.bottom + insets.top))
    }

    var maxDimension: CGFloat {
        return max(self.width, self.height)
    }

    var minDimension: CGFloat {
        return min(self.width, self.height)
    }

    var centerOf: CGPoint {
        return CGPoint(
            x: self.minX + (self.width / 2),
            y: self.minY + (self.height / 2))
    }
    
}
