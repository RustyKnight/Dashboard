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
    }
    
    var data: [NetworkSatelliteMode] = [
        DefaultNetworkSatelliteMode(state: "Registered, home network", mode: .voice, dataMode: false),
//        DefaultNetworkSatelliteMode(state: "Registering", mode: .data, dataMode: false),
//        DefaultNetworkSatelliteMode(state: "Lost", mode: .data, dataMode: true),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        automaticallyAdjustsScrollViewInsets = false
//        let insets = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
//        collectionView?.contentInset = insets
        
        let height: CGFloat = 22.0//navigationController?.navigationBar.frame.size.height ?? UIApplication.shared.statusBarFrame.size.height
        
        collectionView?.contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
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
        let cell = dequeueReusableCell(withReuseIdentifier: Cell.satelliteNetworkMode, for: indexPath)
        if let cell = cell as? NetworkSatelliteCollectionViewCell {
            cell.configure(with: data[indexPath.row], delegate: self)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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

extension CollectionViewController: NetworkSatelliteModeDelegate {
    
    func indexOf(networkSatelliteMode: NetworkSatelliteMode) -> Int? {
        return data.index { (element) -> Bool in
            return element == networkSatelliteMode
        }
    }
    
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, dataDidChangeTo mode: Bool) {
        guard let index = indexOf(networkSatelliteMode: networkSatelliteMode) else {
            return
        }
        
        var networkMode = DefaultNetworkSatelliteMode(from: networkSatelliteMode)
        networkMode.dataMode = mode
        data[index] = networkMode
        
        updateCell(at: index)
    }
    
    func networkSatelliteMode(_ networkSatelliteMode: NetworkSatelliteMode, modeDidChangeTo mode: NetworkMode) {
        guard let index = indexOf(networkSatelliteMode: networkSatelliteMode) else {
            return
        }
        
        var networkMode = DefaultNetworkSatelliteMode(from: networkSatelliteMode)
        networkMode.mode = mode
        data[index] = networkMode
        
        updateCell(at: index)
    }
    
    func updateCell(at index: Int) {
        let animationsEnabled = UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
        UIView.setAnimationsEnabled(animationsEnabled)
    }
}

protocol ReusableCollectionViewCellHandler {
    associatedtype CellIdentifierType: RawRepresentable
}

extension ReusableCollectionViewCellHandler where Self: UICollectionViewController, CellIdentifierType.RawValue == String {
    
    func dequeueReusableCell(withReuseIdentifier identifier: CellIdentifierType, for indexPath: IndexPath) -> UICollectionViewCell {
        return (collectionView?.dequeueReusableCell(withReuseIdentifier: identifier.rawValue, for: indexPath))!
    }
    
}
