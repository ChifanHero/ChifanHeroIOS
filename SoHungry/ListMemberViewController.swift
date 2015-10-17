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

    @IBOutlet weak var memberTable: ImageProgressiveTableView!
    
    @IBOutlet weak var headerView: ListHeaderView!
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
        memberTable.imageDelegate = self
        loadTableData()
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
    
    private func loadTableData() {
        if listId != nil {
            let request : GetListByIdRequest = GetListByIdRequest(id: listId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getListById(request, responseHandler: { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response != nil && response!.result != nil {
                        self.member += response!.result!.dishes
                        self.memberTable.reloadData()
                    }
                })
                
            })
            
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
