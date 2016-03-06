//
//  ListMemberViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListMemberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListHeaderViewDelegate, ImageProgressiveTableViewDelegate {
    
    var listId : String?
    
    var member : [Dish] = [Dish]()
    
    
    @IBOutlet weak var waitingView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memberTable: ImageProgressiveTableView!
    
    @IBOutlet weak var headerView: ListHeaderView!
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
        headerView.baseVC = self
        headerView.listId = listId
        memberTable.imageDelegate = self
        loadTableData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("list member view will appear")
        let selectedCellIndexPath : NSIndexPath? = self.memberTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.memberTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        loadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadTableData() {
        self.waitingView.hidden = false
        self.activityIndicator.startAnimating()
        if listId != nil {
            let request : GetListByIdRequest = GetListByIdRequest(id: listId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getListById(request, responseHandler: { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response != nil && response!.result != nil {
                        self.member.removeAll()
                        self.member += response!.result!.dishes
                        self.headerView.likeCount = response?.result?.likeCount
                        self.headerView.bookmarkCount = response?.result?.favoriteCount
                        self.fetchImageDetails()
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
    
    private func fetchImageDetails() {
        for dish : Dish in self.member {
            var url : String? = dish.picture?.original
            if url == nil {
                url = ""
            }
            if url != nil {
                let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                self.images.append(record)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.memberTable, indexPath: indexPath)
        cell?.setUp(dish: member[indexPath.section], image: imageDetails.image!)
        
        switch (imageDetails.state){
        case PhotoRecordState.New:
            if (!tableView.dragging && !tableView.decelerating) {
                self.memberTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            }
        default: break
        }
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return member.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DishTableViewCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func addCandidate(){
        self.performSegueWithIdentifier("addCandidate", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "addCandidate" {
            let navigationController : UINavigationController = segue.destinationViewController as! UINavigationController
            
            let listCandidateController : ListCandidateViewController = navigationController.childViewControllers[0] as! ListCandidateViewController
            var memberIds = [String]()
            for dish : Dish in self.member {
                if dish.id != nil {
                    memberIds.append(dish.id!)
                }
            }
            listCandidateController.memberIds = memberIds
            listCandidateController.currentListId = listId
        }
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.images[indexPath.section]
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.memberTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
        self.memberTable.loadImageForVisibleCells(&pendingOperations)
        pendingOperations.downloadQueue.suspended = false
    }
    
    // As soon as the user starts scrolling, suspend all operations
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pendingOperations.downloadQueue.suspended = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView == self.memberTable {
                self.memberTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
                self.memberTable.loadImageForVisibleCells(&pendingOperations)
                pendingOperations.downloadQueue.suspended = false
            }
        }
    }

}
