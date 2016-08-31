//
//  CollectionViewVerticalStackLayout.swift
//  Dashboard
//
//  Created by Shane Whitehead on 31/8/16.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import Foundation
import UIKit

public class CollectionViewVerticalStackLayout: UICollectionViewLayout {
	
	var cache: [UICollectionViewLayoutAttributes] = []
	
	var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0.0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.size.width - (insets.left + insets.right)
	}
	
	public override func prepare() {
		guard let collectionView = collectionView else {
			return
		}
		if cache.isEmpty {
			
			let width = contentWidth
			var yOffset: [CGFloat] = []
			for item in 0..<collectionView.numberOfItems(inSection: 0) {
				let indexPath = IndexPath(item: item, section: 0)
				
			}
		}
	}
	
}
