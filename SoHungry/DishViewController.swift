//
//  DishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

let reuseIdentifier = "photoCollectionCell"
let nib = "PhotoCollectionCell"

class DishViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ImageProgressiveCollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dishId : String?
    
    var dish : Dish?

    @IBOutlet weak var addButton: BubbleButton!
    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var photosCollectionView: ImageProgressiveCollectionView!
    
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.setup(containerView: self.scrollView)
        registerNib()
        // Do any additional setup after loading the view.
        loadData()
    }
    
    private func registerNib() {
        photosCollectionView.registerNib(UINib(nibName: nib, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func loadData() {
        if (dishId != nil) {
            let request : GetDishByIdRequest = GetDishByIdRequest(id: dishId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getDishById(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.dish = (response?.result)!
                    if self.dish != nil {
                        self.topViewContainer.name = self.dish?.name
                        self.topViewContainer.englishName = self.dish?.englishName
                        self.topViewContainer.backgroundImageURL = self.dish?.picture?.original
                    }
                });
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : PhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        // Configure the cell
        let imageDetails = imageForIndexPath(collectionView: self.photosCollectionView, indexPath: indexPath)
        cell.addPhoto(imageDetails.image!)
        
        switch (imageDetails.state){
        case .New:
            self.photosCollectionView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
        default: break
        }
        return cell
    }
    
    func imageForIndexPath(collectionView collectionView : UICollectionView, indexPath : NSIndexPath) -> PhotoRecord {
        return images[indexPath.row]
    }
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        let alertActionVC : UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let chooseFromLibraryAction : UIAlertAction = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imageController.allowsEditing = false
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        let takePhotoAction : UIAlertAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.sourceType = UIImagePickerControllerSourceType.Camera
            imageController.allowsEditing = false
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            alertActionVC.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertActionVC.addAction(chooseFromLibraryAction)
        alertActionVC.addAction(takePhotoAction)
        alertActionVC.addAction(cancelAction)
        self.presentViewController(alertActionVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        addImageToCollectionView(image)
        saveImageInBackground(image)
    }
    
    private func addImageToCollectionView(image: UIImage) {
        let newPhoto : PhotoRecord = PhotoRecord(name: "", url: NSURL())
        newPhoto.image = image
        newPhoto.state = .Native
        images.append(newPhoto)
        let newIndexPath : NSIndexPath = NSIndexPath(forItem: images.count - 1, inSection: 0)
        self.photosCollectionView.insertItemsAtIndexPaths([newIndexPath])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func saveImageInBackground(image: UIImage) {
        
    }
}
