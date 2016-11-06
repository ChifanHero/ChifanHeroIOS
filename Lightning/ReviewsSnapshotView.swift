//
//  ReviewsSnapshotView.swift
//  Lightning
//
//  Created by Shi Yan on 10/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

@IBDesignable class ReviewsSnapshotView: UIView, UITableViewDelegate, UITableViewDataSource{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ReviewsSnapshotView"
    
    var parentViewController : RestaurantMainTableViewController?
    
    var reviews: [Review]?
    
    @IBOutlet weak var reviewsTableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private var newReviewCellHeight: CGFloat = 120
    private var reviewCellHeight: CGFloat = 166
    private var spaceBetweenSections: CGFloat = 10
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.scrollEnabled = false
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if reviews == nil {
                return 0
            } else {
                return reviews!.count
            }
//            return 2
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 166
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if reviews == nil || reviews?.count == 0 {
            return 0
        } else {
            if section == 0 {
                return 10
            } else {
                return 0.1
            }
        }
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: EditableReviewTableViewCell? = tableView.dequeueReusableCellWithIdentifier("editableReviewCell") as? EditableReviewTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "EditableReviewCell", bundle: nil), forCellReuseIdentifier: "editableReviewCell")
                cell = tableView.dequeueReusableCellWithIdentifier("editableReviewCell") as? EditableReviewTableViewCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.addDetailReviewButton.addTarget(self, action: #selector(ReviewsSnapshotView.writeNewReview), forControlEvents: UIControlEvents.TouchUpInside)
            cell?.parentViewController = self.parentViewController
            return cell!
        } else {
            let review: Review = reviews![indexPath.row]
            var cell: ReviewSnapshotTableViewCell? = tableView.dequeueReusableCellWithIdentifier("reviewSnapshotCell") as? ReviewSnapshotTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
                cell = tableView.dequeueReusableCellWithIdentifier("reviewSnapshotCell") as? ReviewSnapshotTableViewCell
            }
            cell?.profileImageButton.addTarget(self, action: #selector(ReviewsSnapshotView.showUserActivity), forControlEvents: .TouchUpInside)
            cell?.review = review.content
            let user = review.user
            if user == nil || user?.nickName == nil {
                cell?.userName = "匿名用户"
            } else {
                cell?.userName = user?.nickName
            }
            
//            if indexPath.section == 2 {
//                cell?.userName = "Peter Huang"
//                //cell?.profileImageView.image = UIImage(named: "peter")
//                cell?.review = "Who tm cares?"
//            }
            return cell!
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if indexPath.section > 0 {
            showReview()
        }
        cell.selected = false
    }
    
    func reloadData() {
        self.reviewsTableView.reloadData()
    }
    
    func writeNewReview() {
        parentViewController?.performSegueWithIdentifier("writeReview", sender: nil)
    }
    
    func showReview() {
        parentViewController?.performSegueWithIdentifier("showReview", sender: nil)
    }
    
    func showUserActivity() {
        parentViewController?.performSegueWithIdentifier("showUserActivity", sender: nil)
    }

    
    func getHeight() -> CGFloat {
        if reviews == nil || reviews?.count == 0 {
            return newReviewCellHeight
        } else {
            return newReviewCellHeight + spaceBetweenSections + reviewCellHeight * CGFloat(reviews!.count)
        }
    }

}
