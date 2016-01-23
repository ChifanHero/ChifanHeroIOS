//
//  ScoreComputer.swift
//  Lightning
//
//  Created by Shi Yan on 1/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation


class ScoreComputer  {
    
    static func getScore(var positive positive: Int?, var negative: Int?, var neutral: Int?) -> String {
        if (positive == nil) {
            positive = 0
        }
        if (negative == nil) {
            negative = 0
        }
        if (neutral == nil) {
            neutral = 0
        }
        if (positive! + negative! + neutral!) == 0{
            return "尚未评价(向左滑动以打分)"
        }
        
        let pos = Double(positive!)
        let neg = Double(negative!)
        let neu = Double(neutral!)
        let result:Double = (pos * 1.0 + neu * 0.7) / (pos + neg + neu) * 100.00
        return String(format:"%.1f", result) + "%"
    }
}