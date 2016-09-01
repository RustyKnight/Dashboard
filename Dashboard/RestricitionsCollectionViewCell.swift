//
//  RestricitionsCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 1/09/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

enum RestrictedService {
    case sms
    case call
    case broadBandData
    
    static let all: [RestrictedService] = [
        .sms,
        .call,
        .broadBandData
    ]
}

protocol RestrictedServiceState: DashboardData {
    func isRestricted(service: RestrictedService) -> Bool
}

protocol RestrictedServiceObserver {
    func restrictedService(_ service: RestrictedService, didChangeTo: Bool, `for`: RestrictedServiceState)
}

struct DefaultRestrictedServiceState: RestrictedServiceState {
    var state: [RestrictedService: Bool]
    
    init(sms: Bool, call: Bool, broadband: Bool) {
        state = [
            .sms: sms,
            .call: call,
            .broadBandData: broadband
        ]
    }
    
    init(from: RestrictedServiceState) {
        self.init(sms: from.isRestricted(service: .sms),
                  call: from.isRestricted(service: .call),
                  broadband: from.isRestricted(service: .broadBandData))
    }
    
    func isRestricted(service: RestrictedService) -> Bool {
        return state[service]!
    }
    
    func isEqual(to: DashboardData) -> Bool {
        guard let to = to as? RestrictedServiceState else {
            return false
        }
        
        var isEqual = true
        for service in RestrictedService.all {
            if isRestricted(service: service) != to.isRestricted(service: service) {
                isEqual = false
                break
            }
        }
        return isEqual
    }
}

class RestricitionsCollectionViewCell: DashboardCollectionViewCell {
    
    @IBOutlet weak var broadbandDataLockButton: UIButton!
    @IBOutlet weak var callLockButton: UIButton!
    @IBOutlet weak var smsLockButton: UIButton!
    
    var serviceFor: [UIButton: RestrictedService]!
    var observer: RestrictedServiceObserver?
    var state: RestrictedServiceState?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        
        smsLockButton.setTitle(nil, for: [])
        callLockButton.setTitle(nil, for: [])
        broadbandDataLockButton.setTitle(nil, for: [])
        
        serviceFor = [
            smsLockButton: .sms,
            callLockButton: .call,
            broadbandDataLockButton: .broadBandData
        ]
    }
    
    func configure(with state: RestrictedServiceState, observer: RestrictedServiceObserver) {
        self.observer = observer
        self.state = state
        
        let lockIcon = #imageLiteral(resourceName: "dashboard-feature-restriction-locked")
        let unlockedIcon = #imageLiteral(resourceName: "dashboard-feature-restriction-unlocked")
        
        smsLockButton.setImage(state.isRestricted(service: .sms) ? lockIcon : unlockedIcon, for: [])
        callLockButton.setImage(state.isRestricted(service: .call) ? lockIcon : unlockedIcon, for: [])
        broadbandDataLockButton.setImage(state.isRestricted(service: .broadBandData) ? lockIcon : unlockedIcon, for: [])
    }

    @IBAction func restrictionStateChanged(_ sender: UIButton) {
        guard let observer = observer else {
            return
        }
        guard let state = state else {
            return
        }
        guard let service = serviceFor[sender] else {
            return
        }
        
        let current = state.isRestricted(service: service)
        observer.restrictedService(service, didChangeTo: !current, for: state)
    }
}
