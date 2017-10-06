//
//  RatingStarUtil.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/11/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class RatingStarUtil {
    
    class func noRating(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
    }
    
    class func ratingOne(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(1.0))
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
    }
    
    class func ratingTwo(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(2.0))
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(2.0))
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
    }
    
    class func ratingThree(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(3.0))
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(3.0))
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(3.0))
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
    }
    
    class func ratingFour(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(4.0))
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(4.0))
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(4.0))
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(4.0))
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: UIColor.gray)
    }
    
    class func ratingFive(ratingOneImageView: UIImageView, ratingTwoImageView: UIImageView, ratingThreeImageView: UIImageView, ratingFourImageView: UIImageView, ratingFiveImageView: UIImageView) {
        
        ratingOneImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(5.0))
        ratingTwoImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(5.0))
        ratingThreeImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(5.0))
        ratingFourImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(5.0))
        ratingFiveImageView.renderColorChangableImage(UIImage(named: "ChifanHero_RatingStar.png")!, fillColor: ScoreComputer.getScoreColor(5.0))
    }
}
