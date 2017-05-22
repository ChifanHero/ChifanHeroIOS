//
//  NewReviewViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class NewReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate, UIGestureRecognizerDelegate, NewReviewRatingSectionDelegate {
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var imagePoolView: UICollectionView!
    
    @IBOutlet weak var bottomDistanceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ratingRootView: UIView!
    
    var restaurant: Restaurant!
    
    var reviewId: String?
    
    var rating: Int = 0
    
    var images: [UIImage] = []

    let reviewManager = PostReviewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCancelButton()
        self.addDoneButton()
        self.observeKeyboard()
        self.imagePoolView.register(UINib(nibName: "RemovablePhotoCell", bundle: nil), forCellWithReuseIdentifier: "removablePhotoCell")
        self.configureRatingSection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewTextView.becomeFirstResponder()
    }
    
    private func configureRatingSection() {
        let ratingView = UINib(
            nibName: "NewReviewRatingSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! NewReviewRatingSectionView
        
        ratingView.frame = CGRect(x: 0, y: 0, width: ratingRootView.frame.width, height: ratingRootView.frame.height)
        ratingView.delegate = self
        ratingView.loadUserRating()
        self.ratingRootView.addSubview(ratingView)
    }
    
    func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(submit), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel() {
        self.reviewTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func submit() {
        if restaurant != nil {
            let reviewOperation = PostReviewOperation(rating: self.rating, content: reviewTextView.text, restaurantId: restaurant.id!, retryTimes: 3) { (success, review) in
                
                if success {
                    self.reviewId = review?.id
                    for image in self.images {
                        let uploadOperation = PhotoUploadOperation(photo: image, restaurantId: self.restaurant.id!, reviewId: self.reviewId!, retryTimes: 3, completion: { (success, picture) in
                            print(success)
                            
                        })
                        self.reviewManager.queue.addOperation(uploadOperation)
                    }
                }
            }
            self.reviewManager.queue.addOperation(reviewOperation)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewViewController.handleKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func handleKeyboardDidShowNotification(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomDistanceConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RemovablePhotoCollectionViewCell? = imagePoolView.dequeueReusableCell(withReuseIdentifier: "removablePhotoCell", for: indexPath) as? RemovablePhotoCollectionViewCell
        
        // Configure the cell
        if indexPath.item < images.count {
            cell!.setUp(image: images[indexPath.item])
            cell?.layoutIfNeeded()
            cell!.deleteButton.layer.cornerRadius = cell!.deleteButton.frame.size.width / 2
            cell?.deleteButton.image = UIImage(named: "Cancel_Button.png")
            cell?.bringSubview(toFront: (cell?.deleteButton)!)
            cell!.deleteButton.renderColorChangableImage(UIImage(named: "Cancel_Button.png")!, fillColor: UIColor.red)
            cell!.deleteButton.isHidden = false
            
            cell?.deleteButton.tag = indexPath.item
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewReviewViewController.deleteImage(_:)))
            tap.delegate = self
            cell?.deleteButton.addGestureRecognizer(tap)
        } else {
            cell!.setUpAddingImageCell()
            
        }
        return cell!
    }
    
    func deleteImage(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view!
        let id = tappedImageView.tag
        self.images.remove(at: id)
        self.imagePoolView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == images.count {
            let alert = UIAlertController(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let albumAction = UIAlertAction(title: "相册", style: .default, handler: self.goToAlbum)
            let cameraAction = UIAlertAction(title: "拍摄", style: .default, handler: self.goToCamera)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelNavigation)
            
            alert.addAction(albumAction)
            alert.addAction(cameraAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            var photos = [SKPhoto]()
            for image in images {
                let photo = SKPhoto.photoWithImage(image)// add some UIImage
                photos.append(photo)
            }
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(indexPath.row)
            present(browser, animated: true, completion: {})
        }
    }
    
    // MARK: Photo selection
    func goToAlbum(_ alertAction: UIAlertAction!) -> Void {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = false
        pickerController.maxSelectableCount = 10
        pickerController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerController.sourceType = DKImagePickerControllerSourceType.photo
        pickerController.allowMultipleTypes = false
        pickerController.allowsLandscape = false
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.processSelectedPhotosFromPhotoLibrary(assets)
        }
        self.present(pickerController, animated: true) {}
    }
    
    func goToCamera(_ alertAction: UIAlertAction!) -> Void {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelNavigation(_ alertAction: UIAlertAction!) {
        
    }
    
    func processSelectedPhotosFromPhotoLibrary(_ assets: [DKAsset]) {
        var images: [UIImage] = []
        for asset in assets {
            asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                images.append(image!)
                if images.count == assets.count {
                    self.displayImages(images)
                }
            })
        }
    }
    
    //MARK: ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
//        self.reviewTextView.becomeFirstResponder()
        displayImages(images)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        self.reviewTextView.becomeFirstResponder()
    }
    
    func displayImages(_ images: [UIImage]) {
        self.images.append(contentsOf: images)
        imagePoolView.reloadData()
    }
    
    //MARK: NewReviewRatingSectionDelegate
    func getRating() -> Int {
        return rating
    }
    

}
