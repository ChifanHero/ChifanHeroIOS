//
//  RestaurantPhotoSectionView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/14/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

protocol RestaurantPhotoSectionDelegate {
    func showAllPhotos()
    func showSKPhotoBrowser(pageIndex: Int)
}

class RestaurantPhotoSectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imagePoolView: UICollectionView!
    
    @IBAction func showAllPhotos(_ sender: Any) {
        self.delegate.showAllPhotos()
    }
    
    var imagePool: [Picture] = []
    
    var imagePoolContent: [UIImageView] = []
    
    var delegate: RestaurantPhotoSectionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imagePoolView.register(RestaurantImagePoolCollectionViewCell.self, forCellWithReuseIdentifier: "restaurantImagePoolCell")
    }
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagePool.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RestaurantImagePoolCollectionViewCell? = imagePoolView.dequeueReusableCell(withReuseIdentifier: "restaurantImagePoolCell", for: indexPath) as? RestaurantImagePoolCollectionViewCell
        
        // Configure the cell
        cell!.setUp(image: imagePoolContent[indexPath.row].image!)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //            let imagePickerController = ImagePickerController()
        //            imagePickerController.delegate = self
        //            self.presentViewController(imagePickerController, animated: true, completion: nil)
        //let alert = UIAlertController(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //let albumAction = UIAlertAction(title: "相册", style: .default, handler: self.goToAlbum)
        //let cameraAction = UIAlertAction(title: "拍摄", style: .default, handler: self.goToCamera)
        //let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelNavigation)
        
        //alert.addAction(albumAction)
        //alert.addAction(cameraAction)
        //alert.addAction(cancelAction)
        
        //self.present(alert, animated: true, completion: nil)
        
        //            let photoGallery = PhotoGalleryViewController()
        //            photoGallery.parentVC = self
        //            photoGallery.currentIndexPath = indexPath
        //            self.presentViewController(photoGallery, animated: false, completion: nil)
        self.delegate.showSKPhotoBrowser(pageIndex: indexPath.row)
    }

}
