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
        self.navigationController?.navigationBar.translucent = false
        self.addDoneButton()
        doneButton?.enabled = false

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantNominationView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDoneButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("完成", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(RestaurantNominationViewController.completeNomination), forControlEvents: UIControlEvents.TouchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.doneButton = doneButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func completeNomination(){
        DataAccessor(serviceConfiguration: ParseConfiguration()).nominateRestaurantForCollection(nominationRequest, responseHandler: { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("完成", target:self, selector:#selector(RestaurantNominationViewController.unwindToCollectionMember))
                alertView.showSuccess("提名成功", subTitle: "感谢您的提名.\n吃饭英雄会尽快处理您的请求!")
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return restaurants.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: RestaurantNominationCollectionViewCell? = nominationView.dequeueReusableCellWithReuseIdentifier("nominationCell", forIndexPath: indexPath) as? RestaurantNominationCollectionViewCell
    
        // Configure the cell
        cell!.setUp(restaurant: restaurants[indexPath.row])
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        doneButton?.enabled = true
        nominationRequest.collectionId = selectedCollection?.id
        nominationRequest.restaurantId = restaurants[indexPath.row].id
    }
    
    private func searchRestaurant(keyword keyword : String) {
        cleanStates()
        let request: RestaurantSearchRequest = RestaurantSearchRequest()
        request.keyword = keyword
        
        print(keyword)
        print(request.getRequestBody())
        
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.cleanStates()
                    self.restaurants += results
                    self.nominationView?.reloadData()
                }
                
            })
        }
    }
    
    private func cleanStates() {
        self.restaurants.removeAll()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar?.endEditing(true)
        searchRestaurant(keyword: self.searchBar.text!)
    }
    
    func unwindToCollectionMember(){
        self.performSegueWithIdentifier("unwindToCollectionMember", sender: self)
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
