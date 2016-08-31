//
//  WireButton.swift
//  Cioffi
//
//  Created by Shane Whitehead on 20/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

@IBDesignable class WireButton: UIButton {

    @IBInspectable var filled: Bool = false {
        didSet {
            updateDisplay(withTint: isHighlighted || isSelected)
            setNeedsDisplay()
        }
    }

    @IBInspectable var emphasized: Bool = false {
        didSet {
            updateDisplay(withTint: isHighlighted || isSelected)
            setNeedsDisplay()
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
        get {
            return layer.borderWidth
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateDisplay(withTint: isHighlighted)
        }
    }

    override var isSelected: Bool {
        didSet {
            updateDisplay(withTint: isSelected)
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateDisplay(withTint: false)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    internal func setup() {
        borderWidth = 2.0
        layer.borderColor = UIColor.red.cgColor
        filled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.borderColor = titleColor(for: UIControlState())?.cgColor
        layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        //contentEdgeInsets = UIEdgeInsets(top: 0, left: layer.cornerRadius, bottom: 0, right: layer.cornerRadius)
//        print("radius = \(layer.cornerRadius); width = \(layer.borderWidth)")
        updateDisplay(withTint: false)
    }

    func updateDisplay(withTint: Bool) {
        guard var textColor = titleColor(for: state) else {
            return
        }
        if emphasized {
            if let titleLabel = titleLabel {
                titleLabel.textColor = UIColor.white
            }
            backgroundColor = textColor
        } else {
            switch filled {
            case false:
                self.backgroundColor = UIColor.clear
                if withTint {
                    textColor = textColor.with(alpha: 0.2)
                }
                if let titleLabel = titleLabel {
                    titleLabel.textColor = textColor
                }
                layer.borderColor = textColor.cgColor
            case true:
                if let titleLabel = titleLabel {
                    titleLabel.textColor = withTint ? UIColor.white : textColor
                    layer.backgroundColor = withTint ? textColor.cgColor : UIColor.clear.cgColor
                }
            }
        }
    }

}
