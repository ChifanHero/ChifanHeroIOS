//
//  ReviewDetailTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var reviewInfoRootView: UIView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var reviewInfoView: ReviewInfoView!
    
    var review: Review!
    
    var reviewUserProfileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configureReviewInfoView()
        self.setUp()
    }
    
    private func configureReviewInfoView() {
        self.reviewInfoView = UINib(
            nibName: "ReviewInfoView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! ReviewInfoView
        
        self.reviewInfoView.frame = CGRect(x: 0, y: 0, width: self.reviewInfoRootView.frame.width, height: self.reviewInfoRootView.frame.height)
        self.reviewInfoView.review = self.review
        self.reviewInfoView.profileImage = self.reviewUserProfileImage.image
        //self.reviewInfoView.delegate = self
        self.reviewInfoRootView.addSubview(self.reviewInfoView)
    }
    
    private func setUp() {
        self.reviewTextView.text = self.review.content
        
        self.photosCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "photosCollectionViewCell")
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.photosCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCollectionViewCell", for: indexPath)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        let url: URL! = URL(string: review.photos[indexPath.row].original  ?? "")
        imageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
        })
        
        cell.contentView.addSubview(imageView)
        return cell
    }
    
}
