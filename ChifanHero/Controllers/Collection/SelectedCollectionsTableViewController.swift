//
//  SelectedCollectionsTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import MapKit

class SelectedCollectionsTableViewController: AutoNetworkCheckTableViewController, UINavigationControllerDelegate {
    
    var selectedCollections: [SelectedCollection] = []
    
    var request: GetSelectedCollectionsByLatAndLonRequest = GetSelectedCollectionsByLatAndLonRequest()
    
    var selectedCellFrame = CGRect.zero
    
    let transition = ExpandingCellTransition()
    
    var lastUsedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configPullToRefresh()
        self.initialLoadData()
//        self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
        self.configureNavigationController()
        self.tableView.register(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "selectedCollectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarTranslucent(To: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackCollectionsView()
        if locationChangedSignificantly() {
            loadingIndicator.startAnimation()
            refreshData()
        }
    }
    
    func locationChangedSignificantly() -> Bool {
        let currentLocation = userLocationManager.getLocationInUse()
        if lastUsedLocation == nil || currentLocation == nil {
            return false
        }
        let currentCLLocation = CLLocation(latitude: (currentLocation?.lat)!, longitude: (currentLocation?.lon)!)
        let lastCLLocation = CLLocation(latitude: lastUsedLocation!.lat!, longitude: lastUsedLocation!.lon!)
        let distance : CLLocationDistance = currentCLLocation.distance(from: lastCLLocation)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
        
    }
    
    func configPullToRefresh() {
        self.view.insertSubview(pullRefresher, at: 0)
        self.pullRefresher.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }
    
    private func initialLoadData() {
        self.loadingIndicator.startAnimation()
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        refreshData()
    }
    
    override func loadData() {
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).getSelectedCollectionByLocation(request) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    self.lastUsedLocation = self.request.userLocation
                    if response == nil {
                        self.pullRefresher.endRefreshing()
                    } else {
                        self.clearData()
                        if response?.results != nil {
                            if response!.results.count > 0 {
                                self.selectedCollections += response!.results
                                self.tableView.isHidden = false
                            } else {
                                self.setNavigationBarTranslucent(To: false)
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            
                            self.tableView.reloadData()
                            self.pullRefresher.endRefreshing()
                            self.loadingIndicator.stopAnimation()
                        } else {
                            self.loadingIndicator.stopAnimation()
                            self.pullRefresher.endRefreshing()
                            self.setNavigationBarTranslucent(To: false)
                            self.tabBarController?.tabBar.isHidden = false
                        }
                    }
                })
            }
    }
    
    private func clearData() {
        self.selectedCollections.removeAll()
    }
    
    override func refreshData() {
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        super.refreshData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectedCollectionTableViewCell.height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return selectedCollections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCollectionCell") as! SelectedCollectionTableViewCell
        cell.setUp(selectedCollection: selectedCollections[indexPath.section])
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCellFrame = tableView.convert(tableView.cellForRow(at: indexPath)!.frame, to: tableView.superview)
        self.performSegue(withIdentifier: "showCollectionMember", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == selectedCollections.count - 1 {
            return 0
        } else {
            return 10
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionMember" {
            let controller: RestaurantCollectionMembersViewController = segue.destination as! RestaurantCollectionMembersViewController
            controller.selectedCollection = selectedCollections[(sender as! IndexPath).section]
            controller.lastUsedLocation = self.lastUsedLocation
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            transition.operation = UINavigationControllerOperation.push
            transition.duration = 0.80
            transition.selectedCellFrame = self.selectedCellFrame
            
            return transition
        }
        
        if operation == UINavigationControllerOperation.pop {
            transition.operation = UINavigationControllerOperation.pop
            transition.duration = 0.80
            
            return transition
        }
        
        return nil
    }


}
