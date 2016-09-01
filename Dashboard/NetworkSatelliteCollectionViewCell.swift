//
//  NetworkSatelliteCollectionViewCell.swift
//  Dashboard
//
//  Created by Shane Whitehead on 31/08/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

enum NetworkMode {
    case voice
    case data
}

protocol NetworkSatelliteMode: DashboardData {
    var state: String {get}
    var mode: NetworkMode {get}
    var dataMode: Bool {get}
}

protocol NetworkSatelliteModeDelegate {
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, modeDidChangeTo mode: NetworkMode)
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, dataDidChangeTo mode: Bool)
}

struct DefaultNetworkSatelliteMode: NetworkSatelliteMode {
    var state: String
    var mode: NetworkMode
    var dataMode: Bool
    
    init(state: String, mode: NetworkMode, dataMode: Bool) {
        self.state = state
        self.mode = mode
        self.dataMode = dataMode
    }
    
    init(from: NetworkSatelliteMode) {
        self.init(state: from.state, mode: from.mode, dataMode: from.dataMode)
    }
    
    func isEqual(to: DashboardData) -> Bool {
        guard let to = to as? NetworkSatelliteMode else {
            return false
        }
        
        return state == to.state &&
            mode == to.mode &&
            dataMode == to.dataMode
    }
}

func ==(lhs: NetworkSatelliteMode, rhs: NetworkSatelliteMode) -> Bool {
    let lhsAddress = Unmanaged.passUnretained(lhs as AnyObject).toOpaque()
    let rhsAddress = Unmanaged.passUnretained(rhs as AnyObject).toOpaque()
    
    return lhsAddress == rhsAddress
}


class NetworkSatelliteCollectionViewCell: DashboardCollectionViewCell {
    
    @IBOutlet weak var dataModeButton: WireButton!
    @IBOutlet weak var modeToggle: UISegmentedControl!
    @IBOutlet weak var stateLabel: UILabel!
    
    let modeState: [NetworkMode: Int] = [
        .voice: 0,
        .data: 1
    ]
    let selectedModeState: [Int: NetworkMode] = [
        0: .voice,
        1: .data
    ]
    
    var delegate: NetworkSatelliteModeDelegate?
    var networkSatelliteMode: NetworkSatelliteMode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with mode: NetworkSatelliteMode, delegate: NetworkSatelliteModeDelegate?) {
        self.delegate = delegate
        networkSatelliteMode = mode
        
        stateLabel.text = mode.state
        modeToggle.selectedSegmentIndex = modeState[mode.mode]!
        dataModeButton.isHidden = mode.mode == .voice
        
        dataModeButton.emphasized = true
        if mode.dataMode {
            dataModeButton.setTitle("Deactivate", for: [])
            dataModeButton.setTitleColor(UIColor.red, for: [])
        } else {
            dataModeButton.setTitle("Activate", for: [])
            dataModeButton.setTitleColor(UIColor.green, for: [])
        }
    }
    
    @IBAction func dataModeChanged(_ sender: AnyObject) {
        print("Data changed")
        guard let networkSatelliteMode = networkSatelliteMode else {
            return
        }
        delegate?.networkSatelliteMode(networkSatelliteMode, dataDidChangeTo: !networkSatelliteMode.dataMode)
    }
    
    @IBAction func modeStateChanged(_ sender: AnyObject) {
        print("Mode changed")
        guard let networkSatelliteMode = networkSatelliteMode else {
            return
        }
        guard let mode = selectedModeState[modeToggle.selectedSegmentIndex] else {
            return
        }
        delegate?.networkSatelliteMode(networkSatelliteMode, modeDidChangeTo: mode)
    }
}
