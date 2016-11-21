//
//  UserActivityTableViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class UserActivityTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userUploadedImagePoolView: UICollectionView!
    
    var cellHeight: CGFloat!
    
    var userUploadedImagePool: [Picture] = []
    
    var userUploadedImagePoolContent: [UIImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUserUploadedImagePoolView()
        self.loadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureUserUploadedImagePoolView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height - 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.userUploadedImagePoolView?.registerClass(UserUploadedImageCollectionViewCell.self, forCellWithReuseIdentifier: "userUploadedImageCell")
        self.userUploadedImagePoolView?.backgroundColor = UIColor.whiteColor()
        self.userUploadedImagePoolView?.showsHorizontalScrollIndicator = false
        self.userUploadedImagePoolView?.showsVerticalScrollIndicator = false
        
        self.cellHeight = 200
    }
    
    private func loadData(){
        let request: GetReviewByIdRequest = GetReviewByIdRequest(id: "LPkb7btsVY")
        DataAccessor(serviceConfiguration: ParseConfiguration()).getReviewById(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if response?.result?.photos != nil {
                    self.loadUserUploadedImagePool((response?.result?.photos)!)
                }
            });
        }
    }
    
    private func loadUserUploadedImagePool(photos: [Picture]){
        userUploadedImagePool.removeAll()
        for photo in photos {
            self.userUploadedImagePool.append(photo)
        }
        self.downloadImages()
    }
    
    private func downloadImages(){
        for image in userUploadedImagePool {
            let imageView = UIImageView()
            var url: String = ""
            url = image.original!
            imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.userUploadedImagePoolView.reloadData()
            })
            self.userUploadedImagePoolContent.append(imageView)
        }
    }
    
    func setUp(userActivity: UserActivity){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString((userActivity.lastUpdateTime! as NSString).substringToIndex(10))
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date!)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        self.dateLabel.text = String(month) + "月" + String(day) + "日"
        self.commentLabel.text = userActivity.review?.content
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userUploadedImagePool.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UserUploadedImageCollectionViewCell? = userUploadedImagePoolView.dequeueReusableCellWithReuseIdentifier("userUploadedImageCell", forIndexPath: indexPath) as? UserUploadedImageCollectionViewCell
        
        // Configure the cell
        cell?.setUpImage(userUploadedImagePoolContent[indexPath.row].image!)
        return cell!
    }

}
