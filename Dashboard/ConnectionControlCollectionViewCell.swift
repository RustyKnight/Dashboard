//
//  ConnectionControlCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

protocol ConnectionControl: DashboardData {
}

struct DefaultConnectionControl: ConnectionControl {
    func isEqual(to: DashboardData) -> Bool {
        guard to is ConnectionControl else {
            return false
        }        
        return true
    }
}

class ConnectionControlCollectionViewCell: DashboardCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
