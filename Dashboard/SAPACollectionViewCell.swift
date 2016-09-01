//
//  SAPACollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

protocol SAPAStatus: DashboardData {
    var isActive: Bool {get}
}

protocol SAPAStatusObserver {
    func sapaStatus(_ status: SAPAStatus, didChangeTo state: Bool)
}

struct DefaultSAPAStatus: SAPAStatus {
    let isActive: Bool
    
    func isEqual(to: DashboardData) -> Bool {
        guard let to = to as? SAPAStatus else {
            return false
        }
        
        return isActive == to.isActive
    }
}

class SAPACollectionViewCell: DashboardCollectionViewCell {

    @IBOutlet weak var statusButton: WireButton!
    
    var status: SAPAStatus?
    var observer: SAPAStatusObserver?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with status: SAPAStatus, observer: SAPAStatusObserver) {
        self.status = status
        self.observer = observer
        
        if status.isActive {
            statusButton.setTitle("Deactivate", for: [])
            statusButton.setTitleColor(UIColor.red, for: [])
        } else {
            statusButton.setTitle("Activate", for: [])
            statusButton.setTitleColor(UIColor.green, for: [])
        }
    }

    @IBAction func statusDidChange(_ sender: AnyObject) {
        guard let observer = observer else {
            return
        }
        guard let status = status else {
            return
        }
        
        observer.sapaStatus(status, didChangeTo: !status.isActive)
    }
}
