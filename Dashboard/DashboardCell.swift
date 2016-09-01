//
//  DashboardCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import Foundation
import UIKit

protocol DashboardData {
    func isEqual(to: DashboardData) -> Bool
}

protocol DashboardCell {
    // Should return the "preferred" size of the cell that would fit within the defined
    // size
    func size(fitting: CGSize) -> CGSize
}

protocol CellTitle {
    var title: String { get }
}

protocol CellSubTitle {
    var subTitle: String { get }
}

protocol CellImage {
    var image: UIImage? { get }
}
