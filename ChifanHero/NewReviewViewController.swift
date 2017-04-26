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
        
        imagePoolView.register(UINib(nibName: "RemovablePhotoCell", bundle: nil), forCellWithReuseIdentifier: "removablePhotoCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(NewReviewViewController.cancel(_:)), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addDoneButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(NewReviewViewController.submit(_:)), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func roundRateButtons() {
        let buttons = [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button]
        for button in buttons {
            button?.layer.cornerRadius = 15
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.reviewTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: AnyObject) {
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
//            cell?.showDeleteButton()
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
    
    //MARK: RateButton actions

    @IBAction func rate1(_ sender: AnyObject) {
        toggleButton(1)
    }
    
    @IBAction func rate2(_ sender: AnyObject) {
        toggleButton(2)
    }
    
    @IBAction func rate3(_ sender: AnyObject) {
        toggleButton(3)
    }
    
    @IBAction func rate4(_ sender: AnyObject) {
        toggleButton(4)
    }
    
    @IBAction func rate5(_ sender: AnyObject) {
        toggleButton(5)
    }
    
    fileprivate func toggleButton(_ id : Int) {
        let rateButtons = [rate1Button, rate2Button, rate3Button, rate4Button, rate5Button]
        for index in 0...(rateButtons.count - 1) {
            if index > (id - 1) {
                rateButtons[index]?.unRate({
                    
                })
            } else {
                rateButtons[index]?.rate({
                    
                })
            }
            
        }
        
    }

 

}
