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
    
    static func getScoreColor(_ score: Float) -> UIColor {
        let scoreInHundred = score * 20
        let red: CGFloat = ((255 * (100 - CGFloat(scoreInHundred))) / 100 + 50) / 255
        let green: CGFloat = ((255 * CGFloat(scoreInHundred)) / 100 - 50) / 255
        let blue: CGFloat = 0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
