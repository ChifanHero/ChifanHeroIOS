//
//  ReviewsSnapshotView.swift
//  Lightning
//
//  Created by Shi Yan on 10/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class ReviewsSnapshotView: UIView, UITableViewDelegate, UITableViewDataSource {

    var view: UIView = UIView()
    var reviewsTableView: UITableView = UITableView()
    
    var parentViewController: RestaurantMainTableViewController?
    
    var reviews: [Review]?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Storyboard
    }
    
    private var newReviewCellHeight: CGFloat = 120
    private var reviewCellHeight: CGFloat = 166
    private var spaceBetweenSections: CGFloat = 10
    
    private func Setup(){
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.addSubview(view)
        reviewsTableView.frame = self.bounds
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.isScrollEnabled = false
        self.view.addSubview(reviewsTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 166
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: RatingStarTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as? RatingStarTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "RatingStarCell", bundle: nil), forCellReuseIdentifier: "ratingStarCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as? RatingStarTableViewCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.delegate = parentViewController as! RatingStarCellDelegate
            return cell!
        } else {
            let review: Review = reviews![indexPath.row]
            var cell: ReviewSnapshotTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as? ReviewSnapshotTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as? ReviewSnapshotTableViewCell
            }
            cell?.profileImageButton.addTarget(self, action: #selector(ReviewsSnapshotView.showUserActivity), for: .touchUpInside)
            cell?.review = review.content
            let user = review.user
            if user == nil || user?.nickName == nil {
                cell?.userName = "匿名用户"
            } else {
                cell?.userName = user?.nickName
            }
            cell?.time = review.lastUpdateTime
            
//            if indexPath.section == 2 {
//                cell?.userName = "Peter Huang"
//                //cell?.profileImageView.image = UIImage(named: "peter")
//                cell?.review = "Who tm cares?"
//            }
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        if indexPath.section > 0 {
            showReview()
        }
        cell.isSelected = false
    }
    
    func reloadData() {
        self.reviewsTableView.reloadData()
    }
    
    func writeNewReview() {
        parentViewController?.performSegue(withIdentifier: "writeReview", sender: nil)
    }
    
    func showReview() {
        parentViewController?.performSegue(withIdentifier: "showReview", sender: nil)
    }
    
    func showUserActivity() {
        parentViewController?.performSegue(withIdentifier: "showUserActivity", sender: nil)
    }

    
    func getHeight() -> CGFloat {
        if reviews == nil || reviews?.count == 0 {
            return newReviewCellHeight
        } else {
            return newReviewCellHeight + spaceBetweenSections + reviewCellHeight * CGFloat(reviews!.count)
        }
    }
    
    func resetRatingStar() {
        if let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as? RatingStarTableViewCell {
            cell.reset()
        }
        self.reviewsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

}
