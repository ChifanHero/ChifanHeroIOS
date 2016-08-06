//
//  HomepageTableViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/29/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class HomepageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{

    static var height: CGFloat = 200
    
    var titleLabel: UILabel?
    
    var previewCollectionView: UICollectionView?
    
    var restaurants: [Restaurant] = []
    
    var parentVC: UIViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureCell(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.previewCollectionView = UICollectionView(frame: CGRect() , collectionViewLayout: layout)
        self.previewCollectionView?.delegate = self
        self.previewCollectionView?.dataSource = self
        self.previewCollectionView?.registerClass(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: "previewCollectionCell")
        //self.previewCollectionView?.pagingEnabled = true
        self.previewCollectionView?.backgroundColor = UIColor.whiteColor()
        self.previewCollectionView?.showsHorizontalScrollIndicator = false
        self.previewCollectionView?.showsVerticalScrollIndicator = false
        self.previewCollectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.contentView.addSubview(previewCollectionView!)
        
        self.titleLabel = UILabel()
        titleLabel?.text = "Hello"
        self.contentView.addSubview(titleLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.previewCollectionView?.frame = CGRect(x: 0, y: 60, width: self.contentView.frame.width, height: self.contentView.frame.height - 60)
        
        let layout: CenterCellCollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.contentView.frame.width - 80, height: self.contentView.frame.height - 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Horizontal
        self.previewCollectionView?.setCollectionViewLayout(layout, animated: true)
        
        self.titleLabel?.frame = CGRect(x: 40, y: 10, width: 200, height: 40)
    }
    
    func setUp(title title: String, restaurants: [Restaurant], parentVC: UIViewController) {
        self.titleLabel!.text = title
        self.restaurants.removeAll()
        self.restaurants += restaurants
        self.parentVC = parentVC
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return restaurants.count
        return restaurants.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = previewCollectionView!.dequeueReusableCellWithReuseIdentifier("previewCollectionCell", forIndexPath: indexPath) as! PreviewCollectionViewCell
        cell.setUp(restaurant: restaurants[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let restaurant = self.restaurants[indexPath.row]
        let selectedCell = self.previewCollectionView?.cellForItemAtIndexPath(indexPath) as! PreviewCollectionViewCell
        (self.parentVC as! HomeViewController).selectedImageView = selectedCell.restaurantImageView
        (self.parentVC as! HomeViewController).selectedRestaurantName = selectedCell.restaurantNameLabel!.text
        (self.parentVC as! HomeViewController).selectedRestaurantId = restaurant.id
        (self.parentVC as! HomeViewController).handleTransition()
    }

}

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            
            if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(cvBounds) {
                
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                        continue
                    }
                    
                    if candidateAttributes != nil {
                        if velocity.x > 0 {
                            candidateAttributes = attributes
                        }
                    }
                    else { // == First time in the loop == //
                        
                        candidateAttributes = attributes;
                        continue;
                    }
                }
                return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
            }
        }
        
        // Fallback
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
    
}
