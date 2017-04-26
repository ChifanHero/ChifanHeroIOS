//
//  RankColorPicker.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

class RankColorPicker {
    static func colorPicker(rank: Int) -> UIColor{
        switch rank {
        case 1:
            return UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0) //black
        case 2:
            return UIColor(red: 205 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1.0) //red
        case 3:
            return UIColor(red: 174 / 255, green: 119 / 255, blue: 63 / 255, alpha: 1.0) //brown
        case 4:
            return UIColor(red: 166 / 255, green: 76 / 255, blue: 166 / 255, alpha: 1.0) //purple
        case 5:
            return UIColor(red: 70 / 255, green: 70 / 255, blue: 255 / 255, alpha: 1.0) //blue
        case 6:
            return UIColor(red: 0 / 255, green: 46 / 255, blue: 0 / 255, alpha: 1.0) //green
        case 7:
            return UIColor(red: 95 / 255, green: 44 / 255, blue: 0 / 255, alpha: 1.0) //orange
        case 8:
            return UIColor(red: 100 / 255, green: 75 / 255, blue: 0 / 255, alpha: 1.0) //yellow
        default:
            return UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1.0) //gray
        }
    }
}
