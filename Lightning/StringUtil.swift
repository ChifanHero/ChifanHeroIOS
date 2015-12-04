//
//  Levenshtein.swift
//  Lightning
//
//  Created by Shi Yan on 8/24/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


class StringUtil {
    
    class func LevenshteinDistance(s1:NSString, s2:NSString) -> Int {
        let n = s1.length
        let m = s2.length
        if (n == 0) { return 0 }
        if (m == 0) { return 0 }
        
        var v0:Array<Int> = Array()
        var v1:Array<Int> = Array()
        for r in 0..<m+1 { v0.append(r); v1.append(0) }
        
        for i in 0..<n {
            v1[0] = i + 1
            for j in 0..<m {
                let sChar = s1.substringWithRange(NSRange(location: i, length: 1)) as NSString
                let tChar = s2.substringWithRange(NSRange(location: j, length: 1)) as NSString
                
                let cost:Int = sChar.isEqualToString(tChar as String) ? 0 : 1
                
                v1[j+1] = min(v1[j] + 1, v0[j+1] + 1, v0[j] + cost)
            }
            
            for j in 0..<v0.count {
                v0[j] = v1[j]
            }
        }
        return v1[m]
    }
    
    class func getRelevanceScore(baseString : String?, searchText str2 : String?) -> Float{
        if baseString == nil || str2 == nil {
            return 0.0
        } else {
            var score : Float = 0.0
            if let searchTextArr : [String]? = tokenize(str2) {
                for str : String  in searchTextArr! {
                    let distance = LevenshteinDistance(baseString!, s2: str)
                    let bigger = max(baseString!.characters.count, str.characters.count)
                    let pct = Float(bigger-distance)/Float(bigger)
                    score += pct
                }
            }
            return score
        }
    }
    
    class func tokenize(str : String?) -> [String]? {
        if str == nil {
            return nil
        } else {
            return str!.componentsSeparatedByString(" ")
        }
    }
}