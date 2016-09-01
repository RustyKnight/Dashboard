//
//  DiagnosticsCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

protocol Diagnostics: DashboardData {
}

struct DefaultDiagnostics: Diagnostics {
    func isEqual(to: DashboardData) -> Bool {
        guard to is Diagnostics else {
            return false
        }
        return true
    }
}

class DiagnosticsCollectionViewCell: DashboardCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
