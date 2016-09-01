//
//  CollectionViewController.swift
//  Dashboard
//
//  Created by Shane Whitehead on 31/08/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, ReusableCollectionViewCellHandler {

    typealias CellIdentifierType = Cell
    
    enum Cell: String {
        case satelliteNetworkMode = "Cell.networkSatelliteMode"
        case restricitions = "Cell.restricitions"
        case sapa = "Cell.sapa"
        case systemAlerts = "Cell.systemAlerts"
        case diganostics = "Cell.diagnostics"
        case connectionControl = "Cell.connectionControl"
    }
    
    var data: [DashboardData] = [
        DefaultNetworkSatelliteMode(state: "Registered, home network", mode: .voice, dataMode: false),
        DefaultSAPAStatus(isActive: false),
        DefaultRestrictedServiceState(sms: true, call: true, broadband: true),
        DefaultSystemAlertStatus(with: [.simAbsent, .criticalBattery, .criticalLowTempature, .poweringDown, .smartNetworkSwitching]),
        DefaultDiagnostics(),
        DefaultConnectionControl()
    ]
    
    var cellPrototypes: [Cell: DashboardCollectionViewCell] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = 22.0
        
        collectionView?.contentInset = UIEdgeInsets(top: height, left: 8, bottom: 0, right: 8)
        
        print("Register")
        loadCell(from: "NetworkSatelliteCollectionViewCell",
                 withIdentifier: .satelliteNetworkMode,
                 forOwner: NetworkSatelliteCollectionViewCell.self)
        loadCell(from: "RestricitionsCollectionViewCell",
                 withIdentifier: .restricitions,
                 forOwner: RestricitionsCollectionViewCell.self)
        loadCell(from: "SAPACollectionViewCell",
                 withIdentifier: .sapa,
                 forOwner: SAPACollectionViewCell.self)
        loadCell(from: "SystemAlertsCollectionViewCell",
                 withIdentifier: .systemAlerts,
                 forOwner: SystemAlertsCollectionViewCell.self)
        loadCell(from: "DiagnosticsCollectionViewCell",
                 withIdentifier: .diganostics,
                 forOwner: DiagnosticsCollectionViewCell.self)
        loadCell(from: "ConnectionControlCollectionViewCell",
                 withIdentifier: .connectionControl,
                 forOwner: ConnectionControlCollectionViewCell.self)
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
    }
    
    func loadCell(from: String, withIdentifier identifier: Cell, forOwner owner: Any?) {
        let nib = UINib(nibName: from, bundle: nil)
        registerReusableCell(from: nib, for: identifier)
        
        // This is needed to stop it from crashing :P
        cellPrototypes[identifier] = nib.instantiate(withOwner: owner, options: nil)[0] as? DashboardCollectionViewCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configure(cell: cell(for: indexPath), at: indexPath)
    }
    
    func cell(`for` indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = cellIdentifer(for: data[indexPath.row]) else {
            fatalError("Unregistered cell for specified data type")
        }
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = cell as? NetworkSatelliteCollectionViewCell, let data = data[indexPath.row] as? NetworkSatelliteMode {
            cell.configure(with: data, delegate: self)
        } else if let cell = cell as? RestricitionsCollectionViewCell, let data = data[indexPath.row] as? RestrictedServiceState {
            cell.configure(with: data, observer: self)
        } else if let cell = cell as? SAPACollectionViewCell, let data = data[indexPath.row] as? SAPAStatus {
            cell.configure(with: data, observer: self)
        } else if let cell = cell as? SystemAlertsCollectionViewCell, let data = data[indexPath.row] as? SystemAlertStatus {
            cell.configure(with: data, observer: self)
//        } else if let cell = cell as? DiagnosticsCollectionViewCell, let data = data[indexPath.row] as? Diagnostics {
//            cell.configure(with: data, observer: self)
        }
        return cell
    }
    
    func cellIdentifer(`for` data: Any) -> Cell? {
        var identifier: Cell? = nil
        
        if let _ = data as? NetworkSatelliteMode {
            identifier = Cell.satelliteNetworkMode
        } else if let _ = data as? RestrictedServiceState {
            identifier = Cell.restricitions
        } else if let _ = data as? SAPAStatus {
            identifier = Cell.sapa
        } else if let _ = data as? SystemAlertStatus {
            identifier = Cell.systemAlerts
        } else if let _ = data as? Diagnostics {
            identifier = Cell.diganostics
        } else if let _ = data as? ConnectionControl {
            identifier = Cell.connectionControl
        }
        
        return identifier
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {

    func protoytpeCell(`for` indexPath: IndexPath) -> DashboardCollectionViewCell {
        guard let identifier = cellIdentifer(for: data[indexPath.row]) else {
            fatalError("Unregistered cell for specified data type")
        }
        return cellPrototypes[identifier]!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard collectionView == self.collectionView else {
            print("Bad collection view")
            return CGSize.zero
        }
        
        let insets = collectionView.contentInset
        let requiredWidth = collectionView.bounds.width - (insets.left + insets.right)
        var viewSize = CGSize()
        let viewCell = configure(cell: protoytpeCell(for: indexPath), at: indexPath)
        if let viewCell = viewCell as? DashboardCollectionViewCell {
            viewSize = viewCell.size(fitting: CGSize(width: requiredWidth, height: 0))
        }
        viewSize.width = requiredWidth
        return viewSize
    }
    
    func indexOf(value: DashboardData) -> Int? {
        return data.index { (element) -> Bool in
            return value.isEqual(to: element)
        }
    }
    
}

extension CollectionViewController: NetworkSatelliteModeDelegate {
    
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, dataDidChangeTo mode: Bool) {
        guard let index = indexOf(value: networkSatelliteMode) else {
            return
        }
        
        var networkMode = DefaultNetworkSatelliteMode(from: networkSatelliteMode)
        networkMode.dataMode = mode
        data[index] = networkMode
        
        updateCell(at: index)
    }
    
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, modeDidChangeTo mode: NetworkMode) {
        guard let index = indexOf(value: networkSatelliteMode) else {
            return
        }
        
        var networkMode = DefaultNetworkSatelliteMode(from: networkSatelliteMode)
        networkMode.mode = mode
        data[index] = networkMode
        
        updateCell(at: index)
    }
    
    func updateCell(at index: Int) {
//        let animationsEnabled = UIView.areAnimationsEnabled
//        UIView.setAnimationsEnabled(false)
        collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
//        UIView.setAnimationsEnabled(animationsEnabled)
    }
}

extension CollectionViewController: RestrictedServiceObserver {
    
    func restrictedService(_ service: RestrictedService, didChangeTo value: Bool, `for` state: RestrictedServiceState) {
        guard let index = indexOf(value: state) else {
            return
        }
        var newState = DefaultRestrictedServiceState(from: state)
        newState.state[service] = value
        data[index] = newState
        
        updateCell(at: index)
    }
    
}

extension CollectionViewController: SAPAStatusObserver {
    
    func sapaStatus(_ status: SAPAStatus, didChangeTo state: Bool) {
        guard let index = indexOf(value: status) else {
            return
        }
        data[index] = DefaultSAPAStatus(isActive: state)
        
        updateCell(at: index)
    }
    
}

extension CollectionViewController: SystemAlertStatusObserver {
    func systemAlertStatus(_ status: SystemAlertStatus, expandedDidChange to: Bool) {
        guard let index = indexOf(value: status) else {
            return
        }
        var newStatus = DefaultSystemAlertStatus(from: status)
        newStatus.isExpanded = to
        data[index] = newStatus
        updateCell(at: index)
    }
}

protocol ReusableCollectionViewCellHandler {
    associatedtype CellIdentifierType: RawRepresentable
}

extension ReusableCollectionViewCellHandler where Self: UICollectionViewController, CellIdentifierType.RawValue == String {
    
    func dequeueReusableCell(withReuseIdentifier identifier: CellIdentifierType, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(from: collectionView!, withReuseIdentifier: identifier, for: indexPath)
    }
    
    func dequeueReusableCell(from collectionView: UICollectionView, withReuseIdentifier identifier: CellIdentifierType, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier.rawValue, for: indexPath)
    }
    
    func registerReusableCell(from nib: UINib, `for` identifier: CellIdentifierType) {
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier.rawValue)
    }
    
}
