//
//  RestaurantReviewSectionView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/14/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

protocol RestaurantReviewSectionDelegate {
    func showReview(_ index: Int)
    func showAllReviews()
}

class RestaurantReviewSectionView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBAction func showAllReviews(_ sender: Any) {
        delegate.showAllReviews()
    }
    
    var delegate: RestaurantReviewSectionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    var parentViewController: RestaurantMainTableViewController?
    
    var reviews: [Review]? {
        didSet {
            self.reviewsTableView.reloadData()
        }
    }
    
    var reviewUserProfileImageContent: [UIImageView] = [] {
        didSet {
            self.reviewsTableView.reloadData()
        }
    }
    
    private func setUp(){
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.isScrollEnabled = false
        self.reviewsTableView.register(UINib(nibName: "RatingStarCell", bundle: nil), forCellReuseIdentifier: "ratingStarCell")
        self.reviewsTableView.register(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
        self.addSubview(reviewsTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if reviews == nil {
                return 0
            } else {
                // Display at most 5 rows
                return min(reviews!.count, 5)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 160
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as! RatingStarTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = parentViewController
            cell.loadUserRating()
            return cell
        } else {
            let review: Review = reviews![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as! ReviewSnapshotTableViewCell
            cell.review = review
            cell.selectionStyle = .none
            if !self.reviewUserProfileImageContent.isEmpty {
                cell.profileImage = self.reviewUserProfileImageContent[indexPath.row]
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            self.showReview(indexPath.row)
        }
    }
    
    private func showReview(_ index: Int) {
        delegate.showReview(index)
    }
    
    func resetRatingStar() {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as! RatingStarTableViewCell
        cell.delegate = parentViewController
        cell.loadUserRating()
        self.reviewsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

}
