//
//  SystemAlertsCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit
//
//enum CriticialTempature {
//    case high
//    case low
//}
//
//enum CriticalBattery {
//    case low
//    case flat
//}

enum SystemAlert: CustomStringConvertible {
//    case criticalTempature(tempature: CriticialTempature)
//    case criticalBattery(state: CriticalBattery)
    case criticalHighTempature
    case criticalLowTempature
    case criticalBattery
    case flatBattery
    case poweringDown
    case simAbsent
    case smartNetworkSwitching
    
    var description: String {
        switch self {
        case .criticalBattery: return "Critical low battery"
        case .flatBattery: return "Flat battery"
        case .criticalHighTempature: return "Critical high tempature"
        case .criticalLowTempature: return "Critical low tempature"
        case .poweringDown: return "Powering down"
        case .simAbsent: return "SIM Absent"
        case .smartNetworkSwitching: return "Smart Network Switching"
        }
    }
}

//func ==(lhs: SystemAlert, rhs: SystemAlert) -> Bool {
//    switch (lhs, rhs) {
//    case (.criticalTempature(let a), .criticalTempature(let b))   where a == b: return true
//    case (.criticalBattery(let a), .criticalBattery(let b)) where a == b: return true
//    case (.poweringDown, .poweringDown): return true
//    case (.simAbsent, .simAbsent): return true
//    case (.smartNetworkSwitching, .smartNetworkSwitching): return true
//    default: return false
//    }
//}

protocol SystemAlertStatus: DashboardData {
    var alerts: [SystemAlert] {get}
    var isExpanded: Bool {get}
}

protocol SystemAlertStatusObserver {
    func systemAlertStatus(_ status: SystemAlertStatus, expandedDidChange: Bool)
}

struct DefaultSystemAlertStatus: SystemAlertStatus {
    var alerts: [SystemAlert]
    var isExpanded: Bool = false
    
    init(with: [SystemAlert]) {
        alerts = with
    }
    
    init(from: SystemAlertStatus) {
        self.init(with: from.alerts)
        isExpanded = from.isExpanded
    }
    
    func isEqual(to: DashboardData) -> Bool {
        guard let to = to as? SystemAlertStatus else {
            return false
        }
        guard to.alerts.count == alerts.count else {
            return false
        }
        guard to.isExpanded == isExpanded else {
            return false
        }
        var isEqual = true
        for alert in alerts {
            if !to.alerts.contains(where: { (value) -> Bool in
                return value == alert
            }) {
                isEqual = false
                break
            }
        }
        return isEqual
    }
}

class SystemAlertsCollectionViewCell: DashboardCollectionViewCell {

    @IBOutlet weak var smartNetworkSwitching: UILabel!
    @IBOutlet weak var poweringDown: UILabel!
    @IBOutlet weak var criticalBatteryLabel: UILabel!
    @IBOutlet weak var criticalTempatureLabel: UILabel!
    @IBOutlet weak var simAbsentLabel: UILabel!
    
    @IBOutlet weak var attentionButton: UIButton!
    
    var labels: [SystemAlert: UILabel]!
    var dynamicOptions: [UILabel]!
    
    var isExpanded: Bool = false {
        didSet {
            for label in self.dynamicOptions {
                label.isHidden = !isExpanded
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dynamicOptions = [
            smartNetworkSwitching,
            poweringDown,
            criticalBatteryLabel,
            criticalTempatureLabel
        ]
        
        labels = [:]
        
        labels[.simAbsent] = simAbsentLabel
        labels[.criticalBattery] = criticalBatteryLabel
        labels[.flatBattery] = criticalBatteryLabel
        labels[.criticalHighTempature] = criticalTempatureLabel
        labels[.criticalLowTempature] = criticalTempatureLabel
        labels[.poweringDown] = poweringDown
        labels[.smartNetworkSwitching] = smartNetworkSwitching
        
//        expandState(to: false)
    }
    
//    func expandState(to state: Bool, animated: Bool = false) {
//        if animated {
//            UIView.animate(withDuration: 0.25) {
//                self.expand(state)
//            }
//        } else {
//            self.expand(state)
//        }
//    }
//    
//    func expand(_ state: Bool) {
//        for label in self.dynamicOptions {
//            label.isHidden = !state
//        }
//    }
    
    var status: SystemAlertStatus?
    var observer: SystemAlertStatusObserver?
    
    func configure(with status: SystemAlertStatus, observer: SystemAlertStatusObserver) {
        self.status = status
        self.observer = observer
        for alert in status.alerts {
            guard let label = labels[alert] else {
                continue
            }
            label.text = alert.description
        }
        
        isExpanded = status.isExpanded
    }

    @IBAction func attentionChanged(_ sender: AnyObject) {
        guard let observer = observer else {
            return
        }
        guard let status = status else {
            return
        }
        observer.systemAlertStatus(status, expandedDidChange: !status.isExpanded)
    }
}
