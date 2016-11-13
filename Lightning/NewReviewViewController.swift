//
//  NewReviewViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import SKPhotoBrowser

let reviewManager = PostReviewManager()
class NewReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var rate1Button: RateButton!
    
    @IBOutlet weak var rate2Button: RateButton!
    
    @IBOutlet weak var rate3Button: RateButton!
    
    @IBOutlet weak var rate4Button: RateButton!
    
    @IBOutlet weak var rate5Button: RateButton!
    
    @IBOutlet weak var imagePoolView: UICollectionView!
    
    @IBOutlet weak var bottomDistanceConstraint: NSLayoutConstraint!
    
    var restaurantId: String?
    
    var rating = 0
    
    @IBOutlet weak var reviewTextView: UITextView!
//    var imagePool: [Picture] = []
    
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layoutIfNeeded()
        addCancelButton()
        addDoneButton()
        roundRateButtons()
        observeKeyboard()
//        self.imagePoolView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "removablePhotoCell")
        
        imagePoolView.registerNib(UINib(nibName: "RemovablePhotoCell", bundle: nil), forCellWithReuseIdentifier: "removablePhotoCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("取消", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(NewReviewViewController.cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addDoneButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("提交", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(NewReviewViewController.submit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func roundRateButtons() {
        let buttons = [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button]
        for button in buttons {
            button.layer.cornerRadius = 15
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.reviewTextView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func submit(sender: AnyObject) {
        if restaurantId != nil {
            let reviewOperation = PostReviewOperation(reviewId: nil, rating: 5, content: reviewTextView.text, restaurantId: restaurantId!, retryTimes: 3) { (success, review) in
                print(success)
                print(review?.id)
            }
            for image in self.images {
                let uploadOperation = PhotoUploadOperation(photo: image, retryTimes: 3, completion: { (success, picture) in
                    print(success)
                    print(picture?.id)
                    if success {
                        reviewOperation.addPhotoId(picture!.id!)
                    }
                    
                })
                reviewOperation.addDependency(uploadOperation)
                reviewManager.queue.addOperation(uploadOperation)
            }
            reviewManager.queue.addOperation(reviewOperation)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewReviewViewController.handleKeyboardDidShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomDistanceConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: RemovablePhotoCollectionViewCell? = imagePoolView.dequeueReusableCellWithReuseIdentifier("removablePhotoCell", forIndexPath: indexPath) as? RemovablePhotoCollectionViewCell
        
        // Configure the cell
        if indexPath.item < images.count {
            cell!.setUp(image: images[indexPath.item])
//            cell?.showDeleteButton()
            cell?.layoutIfNeeded()
            cell!.deleteButton.layer.cornerRadius = cell!.deleteButton.frame.size.width / 2
            cell?.deleteButton.image = UIImage(named: "Cancel_Button.png")
            cell?.bringSubviewToFront((cell?.deleteButton)!)
            cell!.deleteButton.renderColorChangableImage(UIImage(named: "Cancel_Button.png")!, fillColor: UIColor.redColor())
            cell!.deleteButton.hidden = false
            
            cell?.deleteButton.tag = indexPath.item
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewReviewViewController.deleteImage(_:)))
            tap.delegate = self
            cell?.deleteButton.addGestureRecognizer(tap)
        } else {
            cell!.setUpAddingImageCell()
            
        }
        return cell!
    }
    
    func deleteImage(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view!
        let id = tappedImageView.tag
        self.images.removeAtIndex(id)
        self.imagePoolView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == images.count {
            let alert = UIAlertController(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let albumAction = UIAlertAction(title: "相册", style: .Default, handler: self.goToAlbum)
            let cameraAction = UIAlertAction(title: "拍摄", style: .Default, handler: self.goToCamera)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelNavigation)
            
            alert.addAction(albumAction)
            alert.addAction(cameraAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var photos = [SKPhoto]()
            for image in images {
                let photo = SKPhoto.photoWithImage(image)// add some UIImage
                photos.append(photo)
            }
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(indexPath.row)
            presentViewController(browser, animated: true, completion: {})
        }
    }
    
    // MARK: Photo selection
    func goToAlbum(alertAction: UIAlertAction!) -> Void {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = false
        pickerController.maxSelectableCount = 10
        pickerController.assetType = DKImagePickerControllerAssetType.AllPhotos
        pickerController.sourceType = DKImagePickerControllerSourceType.Photo
        pickerController.allowMultipleTypes = false
        pickerController.allowsLandscape = false
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.processSelectedPhotosFromPhotoLibrary(assets)
        }
        self.presentViewController(pickerController, animated: true) {}
    }
    
    func goToCamera(alertAction: UIAlertAction!) -> Void {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelNavigation(alertAction: UIAlertAction!) {
        
    }
    
    func processSelectedPhotosFromPhotoLibrary(assets: [DKAsset]) {
        var images : [UIImage] = []
        for asset in assets {
            asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                images.append(image!)
                if images.count == assets.count {
//                    self.reviewTextView.becomeFirstResponder()
                    self.displayImages(images)
                }
            })
        }
    }
    
    //MARK: ImagePickerDelegate
    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.reviewTextView.becomeFirstResponder()
        displayImages(images)
    }
    func cancelButtonDidPress(imagePicker: ImagePickerController) {
//        self.reviewTextView.becomeFirstResponder()
    }
    
    func displayImages(images: [UIImage]) {
        self.images.appendContentsOf(images)
        imagePoolView.reloadData()
    }
    
    //MARK: RateButton actions

    @IBAction func rate1(sender: AnyObject) {
        toggleButton(1)
    }
    
    @IBAction func rate2(sender: AnyObject) {
        toggleButton(2)
    }
    
    @IBAction func rate3(sender: AnyObject) {
        toggleButton(3)
    }
    
    @IBAction func rate4(sender: AnyObject) {
        toggleButton(4)
    }
    
    @IBAction func rate5(sender: AnyObject) {
        toggleButton(5)
    }
    
    private func toggleButton(id : Int) {
        let rateButtons = [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button]
        for index in 0...(rateButtons.count - 1) {
            if index > (id - 1) {
                rateButtons[index].unRate({
                    
                })
            } else {
                rateButtons[index].rate({
                    
                })
            }
            
        }
        
    }

 

}
