//
//  ReviewPhotosTableViewCell.swift
//  ChifanHero
//
//  Created by Shi Yan on 10/30/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser

class ReviewPhotosTableViewCell: UITableViewCell, TRMosaicLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SKPhotoBrowserDelegate {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var parentViewController: UIViewController?
    
    var pictures: [Picture]? {
        didSet {
            prepareImageViews(pictures: pictures)
            self.photosCollectionView.reloadData()
//            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    var pictureImageViews: [UIImageView] = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photosCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mosaicImageCell")
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        let mosaicLayout = TRMosaicLayout()
        photosCollectionView.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
    }
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        for imageView in pictureImageViews {
            images.append(SKPhoto.photoWithImage(imageView.image!))
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        browser.initializePageIndex(indexPath.row)
        parentViewController?.present(browser, animated: true, completion: nil)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 180
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pictures == nil {
            return 0
        } else {
            return pictures!.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mosaicImageCell", for: indexPath)
        let imageView = pictureImageViews[indexPath.item]
        imageView.frame = cell.contentView.frame
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        return cell
    }
    
    private func prepareImageViews(pictures: [Picture]?) {
        self.pictureImageViews.removeAll()
        pictures?.forEach({ (picture) in
            let imageView = UIImageView()
            var url: URL!
            if let original = picture.original {
                url = URL(string: original)
            } else if let googlePhotoReference = picture.googlePhotoReference {
                let googlePhotoURL: String = UrlUtil.getGooglePhotoReferenceUrl() + googlePhotoReference
                url = URL(string: googlePhotoURL)
            } else {
                url = URL(string: "")
            }
            imageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.photosCollectionView.reloadData()
            })
            self.pictureImageViews.append(imageView)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
