//
//  ListMemberViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantCollectionMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCollectionId: String?
    
    var members: [Restaurant] = [Restaurant]()
    
    
    @IBOutlet weak var waitingView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memberTable: UITableView!
    
    @IBOutlet weak var headerView: ListHeaderView!
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath : NSIndexPath? = self.memberTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.memberTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTableData() {
        self.waitingView.hidden = false
        self.activityIndicator.startAnimating()
        if selectedCollectionId != nil {
            let request : GetRestaurantCollectionMembersRequest = GetRestaurantCollectionMembersRequest(id: selectedCollectionId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantCollectionMembersById(request, responseHandler: { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response != nil && !response!.results.isEmpty {
                        self.members.removeAll()
                        self.members += response!.results
                        self.memberTable.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.waitingView.hidden = true
                        
                    }
                })
                
            })
            
        }
        
    }
    
    func refresh() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: RestaurantCollectionMemberTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCollectionMemberCell", bundle: nil), forCellReuseIdentifier: "restaurantCollectionMemberTableViewCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        }
        cell?.setUp(restaurant: self.members[indexPath.row])
        
        return cell!
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    @objc private func reloadTable() {
        self.memberTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantCollectionMemberTableViewCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func addCandidate(){
        self.performSegueWithIdentifier("addCandidate", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "addCandidate" {
            
        }
    }

}
