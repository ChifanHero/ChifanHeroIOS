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
    var currentIndexPath: IndexPath?
    var onceOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configurePhotoGalleryView()
        self.configureBackButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configurePhotoGalleryView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view!.frame.width, height: self.view!.frame.height - 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        self.photoGalleryView = UICollectionView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50), collectionViewLayout: layout)
        self.photoGalleryView?.delegate = self
        self.photoGalleryView?.dataSource = self
        self.photoGalleryView?.register(PhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "photoGalleryCell")
        self.photoGalleryView?.isPagingEnabled = true
        self.photoGalleryView?.backgroundColor = UIColor.white
        self.photoGalleryView?.showsHorizontalScrollIndicator = false
        self.photoGalleryView?.showsVerticalScrollIndicator = false
        
        self.view.addSubview(photoGalleryView!)
    }
    
    fileprivate func configureBackButton(){
        let backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        backButton.backgroundColor = UIColor.white
        backButton.setImage(UIImage(named: "Back_Button"), for: UIControlState())
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func backButtonAction(){
        dismiss(animated: false, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return parentVC!.imagePool.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoGalleryCollectionViewCell? = photoGalleryView!.dequeueReusableCell(withReuseIdentifier: "photoGalleryCell", for: indexPath) as? PhotoGalleryCollectionViewCell
        cell?.setUpImage(parentVC!.imagePoolContent[indexPath.row].image!)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = currentIndexPath
            self.photoGalleryView!.scrollToItem(at: indexToScrollTo!, at: .centeredHorizontally, animated: false)
            onceOnly = true
        }
        
        
    }

}
