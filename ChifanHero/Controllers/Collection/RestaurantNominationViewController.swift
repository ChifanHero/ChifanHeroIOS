//
//  RestaurantNominationViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Flurry_iOS_SDK

class RestaurantNominationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var nominationView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let nominationRequest: NominateRestaurantRequest = NominateRestaurantRequest()
    var restaurants: [Restaurant] = [Restaurant]()
    var selectedCollection: SelectedCollection?
    var doneButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.clearTitleForBackBarButtonItem()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: self.nominationView!.frame.width / 40 * 18, height: self.nominationView!.frame.width / 40 * 25)
        layout.sectionInset = UIEdgeInsets(top: self.nominationView!.frame.width / 40 * 2, left: self.nominationView!.frame.width / 40 * 1.5, bottom: self.nominationView!.frame.width / 40 * 2, right: self.nominationView!.frame.width / 40 * 1.5)
        layout.minimumInteritemSpacing = self.nominationView!.frame.width / 40 * 0.5
        layout.minimumLineSpacing = self.nominationView!.frame.width / 40 * 2
        self.nominationView?.collectionViewLayout = layout
        
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.isTranslucent = false
        self.addDoneButton()
        doneButton?.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantNominationView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("完成", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(RestaurantNominationViewController.completeNomination), for: UIControlEvents.touchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.doneButton = doneButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func completeNomination(){
        DataAccessor(serviceConfiguration: ParseConfiguration()).nominateRestaurantForCollection(nominationRequest, responseHandler: { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                AlertUtil.showAlertView(buttonText: "完成", infoTitle: "提名成功", infoSubTitle: "感谢您的提名.\n吃饭英雄会尽快处理您的请求!", target: self, buttonAction: #selector(self.unwindToCollectionMember))
            })
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return restaurants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RestaurantNominationCollectionViewCell? = nominationView.dequeueReusableCell(withReuseIdentifier: "nominationCell", for: indexPath) as? RestaurantNominationCollectionViewCell
    
        // Configure the cell
        cell!.setUp(restaurant: restaurants[indexPath.row])
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doneButton?.isEnabled = true
        nominationRequest.collectionId = selectedCollection?.id
        nominationRequest.restaurantId = restaurants[indexPath.row].id
    }
    
    private func searchRestaurant(keyword : String) {
        cleanStates()
        
    }
    
    private func cleanStates() {
        self.restaurants.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.endEditing(true)
        searchRestaurant(keyword: self.searchBar.text!)
    }
    
    func unwindToCollectionMember(){
        self.performSegue(withIdentifier: "unwindToCollectionMember", sender: self)
    }
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
