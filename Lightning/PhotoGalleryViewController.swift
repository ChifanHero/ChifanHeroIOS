//
//  PhotoGalleryViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var photoGalleryView: UICollectionView?
    var parentVC: RestaurantMainTableViewController?
    var currentIndexPath: NSIndexPath?
    var onceOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.configurePhotoGalleryView()
        self.configureBackButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configurePhotoGalleryView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view!.frame.width, height: self.view!.frame.height - 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        
        self.photoGalleryView = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50), collectionViewLayout: layout)
        self.photoGalleryView?.delegate = self
        self.photoGalleryView?.dataSource = self
        self.photoGalleryView?.registerClass(PhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "photoGalleryCell")
        self.photoGalleryView?.pagingEnabled = true
        self.photoGalleryView?.backgroundColor = UIColor.whiteColor()
        self.photoGalleryView?.showsHorizontalScrollIndicator = false
        self.photoGalleryView?.showsVerticalScrollIndicator = false
        
        self.view.addSubview(photoGalleryView!)
    }
    
    private func configureBackButton(){
        let backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.setImage(UIImage(named: "Back_Button"), forState: .Normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
    }
    
    func backButtonAction(){
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return parentVC!.imagePool.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PhotoGalleryCollectionViewCell? = photoGalleryView!.dequeueReusableCellWithReuseIdentifier("photoGalleryCell", forIndexPath: indexPath) as? PhotoGalleryCollectionViewCell
        cell?.setUpImage(parentVC!.imagePoolContent[indexPath.row].image!)
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if !onceOnly {
            let indexToScrollTo = currentIndexPath
            self.photoGalleryView!.scrollToItemAtIndexPath(indexToScrollTo!, atScrollPosition: .CenteredHorizontally, animated: false)
            onceOnly = true
        }
        
        
    }

}
