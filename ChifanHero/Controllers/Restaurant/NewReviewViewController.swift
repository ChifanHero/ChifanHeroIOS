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
    
    var ratingView: NewReviewRatingSectionView!
    
    var restaurant: Restaurant!
    
    var reviewId: String?
    
    var review: Review?
    
    var rating: Int = 0
    
    // Data structure is [downloaded, downloaded, ..., toBeUploaded, toBeUploaded]
    var downloadedImages: [Picture] = []
    var toBeUploadedImages: [UIImage] = []
    var toBeDeletedImageIds: [String] = []

    let reviewManager = PostReviewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCancelButton()
        self.addDoneButton()
        self.observeKeyboard()
        self.imagePoolView.register(UINib(nibName: "RemovablePhotoCell", bundle: nil), forCellWithReuseIdentifier: "removablePhotoCell")
        self.configureRatingSection()
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewTextView.becomeFirstResponder()
    }
    
    private func loadData() {
        self.reviewTextView.text = self.review?.content
        if self.rating == 0 {
            self.rating = self.review?.rating ?? 0
        }
        self.ratingView.loadUserRating()
        if let photos = self.review?.photos {
            for photo in photos {
                self.downloadedImages.append(photo)
            }
        }
        self.imagePoolView.reloadData()
    }
    
    private func configureRatingSection() {
        self.ratingView = UINib(
            nibName: "NewReviewRatingSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! NewReviewRatingSectionView
        
        self.ratingView.frame = CGRect(x: 0, y: 0, width: ratingRootView.frame.width, height: ratingRootView.frame.height)
        self.ratingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.ratingView.delegate = self
        self.ratingView.loadUserRating()
        self.ratingRootView.addSubview(ratingView)
    }
    
    private func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func addDoneButton() {
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
        guard self.rating != 0 else {
            AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "友情提示", infoSubTitle: "请为餐厅打分", target: self, buttonAction: #selector(dismissAlert))
            return
        }
        if let restaurant = self.restaurant {
            self.disableCurrentView()
            
            let notificationOperation = BlockOperation {
                NotificationCenter.default.post(name: Notification.Name(rawValue: REVIEW_UPLOAD_DONE), object: nil)
                OperationQueue.main.addOperation({ () -> Void in
                    self.dismiss(animated: true, completion: nil)
                });
            }
            
            let reviewOperation = PostReviewOperation(rating: self.rating, content: reviewTextView.text, restaurantId: restaurant.id!) { (success, error, review) in
                
                if success {
                    self.reviewId = review?.id
                    for image in self.toBeUploadedImages {
                        let uploadOperation = PhotoUploadOperation(photo: image, restaurantId: self.restaurant.id!, reviewId: self.reviewId!, completion: { (success, picture) in
                            if success {
                                log.debug("Image:\(picture?.id ?? "") upload is done")
                            } else {
                                log.debug("Image upload failed")
                            }
                        })
                        notificationOperation.addDependency(uploadOperation)
                        self.reviewManager.queue.addOperation(uploadOperation)
                    }
                    self.reviewManager.queue.addOperation(notificationOperation)
                } else {
                    if let error = error {
                        if error.code == 209 {
                            UserSessionUtil.deleteSessionToken()
                        }
                        OperationQueue.main.addOperation({ () -> Void in
                            AlertUtil.showErrorAlert(errorCode: error.code, target: self, buttonAction: #selector(self.dismissNoUserSessionAlert))
                        });
                    }
                }
            }
            if let review = self.review {
                reviewOperation.reviewId = review.id
            }
            if self.toBeDeletedImageIds.count > 0 {
                let deleteOperation = PhotoDeleteOperation(photoIds: self.toBeDeletedImageIds, completion: {(success) in
                    if success {
                        log.debug("Image delete is done")
                    } else {
                        log.debug("Image delete failed")
                    }
                })
                self.reviewManager.queue.addOperation(deleteOperation)
                notificationOperation.addDependency(deleteOperation)
            }
            
            notificationOperation.addDependency(reviewOperation)
            self.reviewManager.queue.addOperation(reviewOperation)
        }
    }
    
    private func disableCurrentView() {
        self.view.addSubview(LoadingViewUtil.buildLoadingView(frame: CGRect(x: self.view.frame.width / 2 - 60, y: self.view.frame.height / 2, width: 120, height: 40), text: "正在上传"))
        self.view.isUserInteractionEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewReviewViewController.handleKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func handleKeyboardDidShowNotification(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomDistanceConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissAlert() {
        
    }
    
    func dismissNoUserSessionAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedImages.count + toBeUploadedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagePoolView.dequeueReusableCell(withReuseIdentifier: "removablePhotoCell", for: indexPath) as! RemovablePhotoCollectionViewCell
        
        // Configure the cell
        if indexPath.item < downloadedImages.count + toBeUploadedImages.count {
            cell.layoutIfNeeded()
            cell.deleteButton.layer.cornerRadius = cell.deleteButton.frame.size.width / 2
            cell.deleteButton.image = UIImage(named: "Cancel_Button.png")
            cell.bringSubview(toFront: (cell.deleteButton)!)
            cell.deleteButton.renderColorChangableImage(UIImage(named: "Cancel_Button.png")!, fillColor: UIColor.red)
            cell.deleteButton.isHidden = false
            
            cell.deleteButton.tag = indexPath.item
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.deleteImage(_:)))
            tap.delegate = self
            cell.deleteButton.addGestureRecognizer(tap)
            
            if indexPath.item < downloadedImages.count {
                cell.setUp(thumbnailUrl: self.downloadedImages[indexPath.item].thumbnail!)
            } else {
                cell.setUp(image: toBeUploadedImages[indexPath.item - downloadedImages.count])
            }
        } else {
            cell.setUpAddingImageCell()
            
        }
        return cell
    }
    
    func deleteImage(_ gestureRecognizer: UITapGestureRecognizer) {
        // tappedImageView is image view that was tapped.
        // dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view!
        let id = tappedImageView.tag
        if id < downloadedImages.count {
            self.toBeDeletedImageIds.append(self.downloadedImages[id].id!)
            self.downloadedImages.remove(at: id)
        } else {
            self.toBeUploadedImages.remove(at: id - downloadedImages.count)
        }
        self.imagePoolView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == downloadedImages.count + toBeUploadedImages.count {
            let alert = UIAlertController(title: "添加图片", message: "请选择图片来源", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let albumAction = UIAlertAction(title: "从相册中选择", style: .default, handler: self.goToAlbum)
            let cameraAction = UIAlertAction(title: "拍照上传", style: .default, handler: self.goToCamera)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelNavigation)
            
            alert.addAction(cameraAction)
            alert.addAction(albumAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            var photos = [SKPhoto]()
            for image in downloadedImages {
                let photo = SKPhoto.photoWithImageURL(image.original ?? "", holder: DefaultImageGenerator.generateRestaurantDefaultImage())
                photo.shouldCachePhotoURLImage = true
                photos.append(photo)
            }
            for image in toBeUploadedImages {
                let photo = SKPhoto.photoWithImage(image)
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
        displayImages(images)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    }
    
    func displayImages(_ images: [UIImage]) {
        self.toBeUploadedImages.append(contentsOf: images)
        imagePoolView.reloadData()
    }
    
    //MARK: NewReviewRatingSectionDelegate
    func getRating() -> Int {
        return self.rating
    }
    
    func setRating(rating: Int) {
        self.rating = rating
    }
}
