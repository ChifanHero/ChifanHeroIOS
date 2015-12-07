//
//  ListCandidateSubView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/14/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ListCandidateSubView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ImageProgressiveTableViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ListCandidateSubView"
    
    @IBOutlet weak var subView: ListCandidateConfirmationView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    var contentViewCollapsed = false
    
    var submitButton : UIButton {
        return self.subView.confirmButton
    }
    
    var subViewTopToHeaderViewBottom : NSLayoutConstraint!
    
    var restaurantId : String? {
        didSet {
            searchDish(restaurantId: restaurantId!)
        }
    }
    
    var dishes : [Dish] = [Dish]()
    
    var pendingOperations = PendingOperations()
    var dishImages : [PhotoRecord] = [PhotoRecord]()
    
    @IBOutlet weak var searchResultsTable: ImageProgressiveTableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        searchTextField.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        UISetup()
    }
    
    private func UISetup() {
        subViewTopToHeaderViewBottom = NSLayoutConstraint(item: self.subView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.headerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        subViewTopToHeaderViewBottom.priority = 1000
        subViewTopToHeaderViewBottom.active = false
        subView.layer.cornerRadius = 15
        subView.layer.borderWidth = 1.5
        subView.layer.borderColor = UIColor.lightGrayColor().CGColor
        confirmButton.layer.cornerRadius = 5
        searchResultsTable.hidden = true
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    
    @IBAction func confirm(sender: AnyObject) {
        self.subViewTopToHeaderViewBottom.active = true
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (success) -> Void in
                self.contentViewCollapsed = true
        }
    }

    @IBAction func headerViewTapped(sender: AnyObject) {
        if contentViewCollapsed {
            self.subViewTopToHeaderViewBottom.active = false
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (success) -> Void in
                    self.contentViewCollapsed = false
            }
        }
    }
    
    func searchDish(restaurantId restaurantId : String) {
        let request : DishSearchRequest = DishSearchRequest()
        request.restaurantId = restaurantId
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchDishes(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.cleanStates()
                    self.dishes += results
                    for dish : Dish in results {
                        var url = dish.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.dishImages.append(record)
                    }
                    self.searchResultsTable.hidden = false
                    self.searchResultsTable.reloadData()
                    self.adjustSearchResultsTableHeight()
                }
                
            })
        }
    }
    
    func cleanStates() {
        self.dishImages.removeAll()
        self.dishes.removeAll()
    }
    
    func adjustSearchResultsTableHeight() {
        let originalFrame : CGRect = self.searchResultsTable.frame
        self.searchResultsTable.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.searchResultsTable.contentSize.height)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dishes.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.searchResultsTable, indexPath: indexPath)
        let dish : Dish?
        dish = self.dishes[indexPath.row]
        cell?.setUp(dish: dish!, image: imageDetails.image!)
        switch (imageDetails.state){
        case .New:
            if (!tableView.dragging && !tableView.decelerating) {
                self.searchResultsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            }
        default: break
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return NameOnlyDishTableViewCell.height
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return dishImages[indexPath.row]
    }
}
