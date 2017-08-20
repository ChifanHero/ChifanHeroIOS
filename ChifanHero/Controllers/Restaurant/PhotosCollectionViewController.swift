//
//  PhotosCollectionViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/7/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser

class PhotosCollectionViewController: UICollectionViewController, TRMosaicLayoutDelegate, SKPhotoBrowserDelegate {
    
    var images: [UIImage] = []
    
    var imagePool: [Picture] = []
    
    var imagePoolContent: [UIImageView] = []
    
    var photoAttributionTextView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mosaicImageCell")
        let mosaicLayout = TRMosaicLayout()
        self.collectionView?.collectionViewLayout = mosaicLayout
        mosaicLayout.delegate = self
        self.configPhotoAttributionTextView()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagePool.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mosaicImageCell", for: indexPath)
        let imageView = UIImageView()
        imageView.image  = imagePoolContent[indexPath.item].image
        imageView.frame = cell.contentView.frame
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        cell.backgroundView = imageView
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        for imageView in imagePoolContent {
            images.append(SKPhoto.photoWithImage(imageView.image!))
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        browser.view.addSubview(photoAttributionTextView!)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {
            if self.imagePool[indexPath.item].htmlAttributions.count > 0 {
                self.photoAttributionTextView!.attributedText = self.imagePool[indexPath.item].htmlAttributions[0].attributedStringFromHTML()
                self.photoAttributionTextView!.textAlignment = .center
                self.photoAttributionTextView!.font = .systemFont(ofSize: 16)
            }
        })
    }
    
    func configPhotoAttributionTextView() {
        photoAttributionTextView = UITextView(frame: CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 30))
        photoAttributionTextView!.backgroundColor = UIColor.black
        photoAttributionTextView!.isEditable = false
        photoAttributionTextView!.textColor = UIColor.white
    }
    
    func collectionView(_ collectionView:UICollectionView, mosaicCellSizeTypeAtIndexPath indexPath:IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? TRMosaicCellType.big : TRMosaicCellType.small
    }
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection:Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 4)
    }
    
    func heightForSmallMosaicCell() -> CGFloat {
        return 180
    }
    
    // MARK: - SKPhotoBrowserDelegate
    func didScrollToIndex(_ index: Int) {
        if self.imagePool[index].htmlAttributions.count > 0 {
            self.photoAttributionTextView!.attributedText = self.imagePool[index].htmlAttributions[0].attributedStringFromHTML()
            self.photoAttributionTextView!.textAlignment = .center
            self.photoAttributionTextView!.font = .systemFont(ofSize: 16)
        }
    }
    
    func controlsVisibilityToggled(hidden: Bool) {
        var alpha: CGFloat?
        if hidden {
            alpha = 0
        } else {
            alpha = 1
        }
        UIView.animate(withDuration: 0.2) {
            self.photoAttributionTextView!.alpha = alpha!
        }
    }

}
