//
//  DashboardCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let viewSize = size(fitting: layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = viewSize.height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    func size(fitting: CGSize) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(fitting)
        return size
    }

}
