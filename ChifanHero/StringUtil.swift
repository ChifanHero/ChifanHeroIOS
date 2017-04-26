//
//  Levenshtein.swift
//  Lightning
//
//  Created by Shi Yan on 8/24/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


class StringUtil {
    
    class func LevenshteinDistance(_ s1:NSString, s2:NSString) -> Int {
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
                let sChar = s1.substring(with: NSRange(location: i, length: 1)) as NSString
                let tChar = s2.substring(with: NSRange(location: j, length: 1)) as NSString
                
                let cost:Int = sChar.isEqual(to: tChar as String) ? 0 : 1
                
                v1[j+1] = min(v1[j] + 1, v0[j+1] + 1, v0[j] + cost)
            }
            
            for j in 0..<v0.count {
                v0[j] = v1[j]
            }
        }
        return v1[m]
    }
    
    class func getRelevanceScore(_ baseString : String?, searchText str2 : String?) -> Float{
        if baseString == nil || str2 == nil {
            return 0.0
        } else {
            var score : Float = 0.0
            if let searchTextArr : [String]? = tokenize(str2) {
                for str : String  in searchTextArr! {
                    let distance = LevenshteinDistance(baseString! as NSString, s2: str as NSString)
                    let bigger = max(baseString!.characters.count, str.characters.count)
                    let pct = Float(bigger-distance)/Float(bigger)
                    score += pct
                }
            }
            return score
        }
    }
    
    class func tokenize(_ str : String?) -> [String]? {
        if str == nil {
            return nil
        } else {
            return str!.components(separatedBy: " ")
        }
    }
    
    class func capitalizeString(_ original : String) -> String {
        let tokens : [String] = StringUtil.tokenize(original)!
        var result = ""
        for token in tokens {
            if token == "" {
                continue
            }
            let lowercaseToken = token.lowercased()
            result += lowercaseToken.replacingCharacters(in: lowercaseToken.startIndex..<lowercaseToken.startIndex, with: String(lowercaseToken[lowercaseToken.startIndex]).uppercased())
            result += " "
        }
        return String(result.characters.dropLast())
    }
}
