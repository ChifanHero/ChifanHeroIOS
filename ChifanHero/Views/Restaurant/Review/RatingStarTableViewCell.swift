//
//  EditableReviewTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

protocol RatingStarCellDelegate {
    func writeReview() -> Void
    func recordUserRating(_ rating: Int) -> Void
}

class RatingStarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingOneImageView: UIImageView!
    @IBOutlet weak var ratingTwoImageView: UIImageView!
    @IBOutlet weak var ratingThreeImageView: UIImageView!
    @IBOutlet weak var ratingFourImageView: UIImageView!
    @IBOutlet weak var ratingFiveImageView: UIImageView!
    
    var delegate: RatingStarCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        delegate.recordUserRating(1)
        delegate.writeReview()
    }
    
    func ratingTwoPressed() {
        RatingStarUtil.ratingTwo(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
        delegate.recordUserRating(2)
        delegate.writeReview()
    }
    
    func ratingThreePressed() {
        RatingStarUtil.ratingThree(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
        delegate.recordUserRating(3)
        delegate.writeReview()
    }
    
    func ratingFourPressed() {
        RatingStarUtil.ratingFour(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
        delegate.recordUserRating(4)
        delegate.writeReview()
    }
    
    func ratingFivePressed() {
        RatingStarUtil.ratingFive(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
        delegate.recordUserRating(5)
        delegate.writeReview()
    }
    
}


