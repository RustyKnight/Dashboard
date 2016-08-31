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

protocol NetworkSatelliteMode {
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
}

func ==(lhs: NetworkSatelliteMode, rhs: NetworkSatelliteMode) -> Bool {
    let lhsAddress = Unmanaged.passUnretained(lhs as AnyObject).toOpaque()
    let rhsAddress = Unmanaged.passUnretained(rhs as AnyObject).toOpaque()
    
    return lhsAddress == rhsAddress
}


class NetworkSatelliteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var modeButton: WireButton!
    @IBOutlet weak var modeToggle: UISegmentedControl!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet var verticalSpacingBetweenButtons: NSLayoutConstraint!
    @IBOutlet var dataActiveToBottom: NSLayoutConstraint!
    @IBOutlet var segmentToBottom: NSLayoutConstraint!
    
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
        layer.cornerRadius = 20
        verticalSpacingBetweenButtons.isActive = false
        dataActiveToBottom.isActive = false
        segmentToBottom.isActive = false
    }

    func configure(with mode: NetworkSatelliteMode, delegate: NetworkSatelliteModeDelegate) {
        self.delegate = delegate
        networkSatelliteMode = mode
        
        stateLabel.text = mode.state
        modeToggle.selectedSegmentIndex = modeState[mode.mode]!
        modeButton.isHidden = mode.mode == .voice
        
        verticalSpacingBetweenButtons.isActive = mode.mode == .data
        dataActiveToBottom.isActive = mode.mode == .data
        segmentToBottom.isActive = mode.mode == .voice
        
        print("VericalSpacing = \(verticalSpacingBetweenButtons.isActive)")
        print("buttonToBottom = \(dataActiveToBottom.isActive)")
        print("segmentToBottom = \(segmentToBottom.isActive)")
        
        modeButton.emphasized = true
        if mode.dataMode {
            modeButton.setTitle("Deactivate", for: [])
            modeButton.setTitleColor(UIColor.red, for: [])
        } else {
            modeButton.setTitle("Activate", for: [])
            modeButton.setTitleColor(UIColor.green, for: [])
        }
        heightCalulated = false
    }
    
    var heightCalulated: Bool = false
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        heightCalulated = true
        return layoutAttributes
    }
    
    @IBAction func dataModeChanged(_ sender: AnyObject) {
        guard let networkSatelliteMode = networkSatelliteMode else {
            return
        }
        delegate?.networkSatelliteMode(networkSatelliteMode, dataDidChangeTo: !networkSatelliteMode.dataMode)
    }
    
    @IBAction func modeStateChanged(_ sender: AnyObject) {
        guard let networkSatelliteMode = networkSatelliteMode else {
            return
        }
        guard let mode = selectedModeState[modeToggle.selectedSegmentIndex] else {
            return
        }
        delegate?.networkSatelliteMode(networkSatelliteMode, modeDidChangeTo: mode)
    }
}
