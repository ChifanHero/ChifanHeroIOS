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
        self.loadData()
        self.configureUserUploadedImagePoolView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func configureUserUploadedImagePoolView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.userUploadedImagePoolView.frame.width/3 - 10, height: self.userUploadedImagePoolView.frame.width/3 - 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        self.userUploadedImagePoolView.setCollectionViewLayout(layout, animated: false)
        self.userUploadedImagePoolView.register(UserUploadedImageCollectionViewCell.self, forCellWithReuseIdentifier: "userUploadedImageCell")
        self.userUploadedImagePoolView.backgroundColor = UIColor.white
        self.userUploadedImagePoolView.showsHorizontalScrollIndicator = false
        self.userUploadedImagePoolView.showsVerticalScrollIndicator = false
        
        self.cellHeight = 200
    }
    
    fileprivate func loadData(){
        let request: GetReviewByIdRequest = GetReviewByIdRequest(id: "LPkb7btsVY")
        DataAccessor(serviceConfiguration: ParseConfiguration()).getReviewById(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if response?.result?.photos != nil {
                    self.loadUserUploadedImagePool((response?.result?.photos)!)
                }
            });
        }
    }
    
    fileprivate func loadUserUploadedImagePool(_ photos: [Picture]){
        userUploadedImagePool.removeAll()
        for photo in photos {
            self.userUploadedImagePool.append(photo)
        }
        self.downloadImages()
    }
    
    fileprivate func downloadImages(){
        for image in userUploadedImagePool {
            let imageView = UIImageView()
            var url: String = ""
            url = image.original!
            imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "restaurant_default_background"),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.userUploadedImagePoolView.reloadData()
            })
            self.userUploadedImagePoolContent.append(imageView)
        }
    }
    
    func setUp(_ userActivity: UserActivity){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: (userActivity.lastUpdateTime! as NSString).substring(to: 10))
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date!)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        self.dateLabel.text = String(describing: month) + "月" + String(describing: day) + "日"
        self.commentLabel.text = userActivity.review?.content
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userUploadedImagePool.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserUploadedImageCollectionViewCell? = userUploadedImagePoolView.dequeueReusableCell(withReuseIdentifier: "userUploadedImageCell", for: indexPath) as? UserUploadedImageCollectionViewCell
        
        // Configure the cell
        cell?.setUpImage(userUploadedImagePoolContent[indexPath.row].image!)
        return cell!
    }

}
