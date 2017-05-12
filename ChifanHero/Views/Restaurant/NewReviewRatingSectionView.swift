//
//  NewReviewRatingSectionView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/11/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

protocol NewReviewRatingSectionDelegate {
    func getRating() -> Int
}

class NewReviewRatingSectionView: UIView {
    
    @IBOutlet weak var ratingOneImageView: UIImageView!
    
    @IBOutlet weak var ratingTwoImageView: UIImageView!
    
    @IBOutlet weak var ratingThreeImageView: UIImageView!
    
    @IBOutlet weak var ratingFourImageView: UIImageView!
    
    @IBOutlet weak var ratingFiveImageView: UIImageView!
    
    var delegate: NewReviewRatingSectionDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    func loadUserRating() {
        switch delegate.getRating() {
        case 1:
            self.ratingOnePressed()
        case 2:
            self.ratingTwoPressed()
        case 3:
            self.ratingThreePressed()
        case 4:
            self.ratingFourPressed()
        case 5:
            self.ratingFivePressed()
        default:
            self.reset()
        }
    }
    
    private func setUp() {
        self.reset()
        
        let ratingOneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingOnePressed))
        self.ratingOneImageView.isUserInteractionEnabled = true
        self.ratingOneImageView.addGestureRecognizer(ratingOneTapGestureRecognizer)
        
        let ratingTwoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingTwoPressed))
        self.ratingTwoImageView.isUserInteractionEnabled = true
        self.ratingTwoImageView.addGestureRecognizer(ratingTwoTapGestureRecognizer)
        
        let ratingThreeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingThreePressed))
        self.ratingThreeImageView.isUserInteractionEnabled = true
        self.ratingThreeImageView.addGestureRecognizer(ratingThreeTapGestureRecognizer)
        
        let ratingFourTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingFourPressed))
        self.ratingFourImageView.isUserInteractionEnabled = true
        self.ratingFourImageView.addGestureRecognizer(ratingFourTapGestureRecognizer)
        
        let ratingFiveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingFivePressed))
        self.ratingFiveImageView.isUserInteractionEnabled = true
        self.ratingFiveImageView.addGestureRecognizer(ratingFiveTapGestureRecognizer)
    }
    
    func reset() {
        RatingStarUtil.noRating(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingOnePressed() {
        RatingStarUtil.ratingOne(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingTwoPressed() {
        RatingStarUtil.ratingTwo(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingThreePressed() {
        RatingStarUtil.ratingThree(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingFourPressed() {
        RatingStarUtil.ratingFour(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingFivePressed() {
        RatingStarUtil.ratingFive(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
}
