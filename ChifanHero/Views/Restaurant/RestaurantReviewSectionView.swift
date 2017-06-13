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
    
    private var newReviewCellHeight: CGFloat = 120
    private var reviewCellHeight: CGFloat = 160
    private var spaceBetweenSections: CGFloat = 10
    
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
                return reviews!.count
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
            let cell: RatingStarTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "ratingStarCell") as! RatingStarTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = parentViewController
            return cell
        } else {
            let review: Review = reviews![indexPath.row]
            let cell: ReviewSnapshotTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as! ReviewSnapshotTableViewCell
            cell.review = review
            cell.selectionStyle = .none
            if !self.reviewUserProfileImageContent.isEmpty {
                cell.profileImage = self.reviewUserProfileImageContent[indexPath.row]
            }
            return cell!
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
