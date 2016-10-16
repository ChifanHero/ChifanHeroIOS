//
//  ScoreComputer.swift
//  Lightning
//
//  Created by Shi Yan on 1/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

class ScoreComputer  {
    
    static func getScore(positive positive: Int?, negative: Int?, neutral: Int?) -> String {
        let score: Double = calculateScore(positive: positive, negative: negative, neutral: neutral)
        return String(format:"%.1f", score / 100 * 5)
    }
    
    static func getScoreNum(positive positive: Int?, negative: Int?, neutral: Int?) -> Double {
        return calculateScore(positive: positive, negative: negative, neutral: neutral)
    }
    
    static func getScoreColor(positive positive: Int?, negative: Int?, neutral: Int?) -> UIColor {
        let score: Double = calculateScore(positive: positive, negative: negative, neutral: neutral)
        let red: CGFloat = ((255 * (100 - CGFloat(score))) / 100 + 50) / 255
        let green: CGFloat = ((255 * CGFloat(score)) / 100 - 50) / 255
        let blue: CGFloat = 0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func getScoreColor(score: Double) -> UIColor {
        let scoreInHundred = score * 20
        let red: CGFloat = ((255 * (100 - CGFloat(scoreInHundred))) / 100 + 50) / 255
        let green: CGFloat = ((255 * CGFloat(scoreInHundred)) / 100 - 50) / 255
        let blue: CGFloat = 0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func calculateScore(positive positive: Int?, negative: Int?, neutral: Int?) -> Double {
        var neutral = neutral
        var negative = negative
        var positive = positive
        if (positive == nil) {
            positive = 0
        }
        if (negative == nil) {
            negative = 0
        }
        if (neutral == nil) {
            neutral = 0
        }
        
        let pos = Double(positive!)
        let neg = Double(negative!)
        let neu = Double(neutral!)
        
        if(pos + neg + neu == 0){
            return 0.0
        }
        let result:Double = (pos * 1.0 + neu * 0.7) / (pos + neg + neu) * 100.00
        return result
    }
}
