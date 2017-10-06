//
//  Levenshtein.swift
//  Lightning
//
//  Created by Shi Yan on 8/24/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


class StringUtil {
    
    class func capitalizeFirstLetterOfEachWordInString(_ original : String) -> String {
        let strArray = original.components(separatedBy: " ")
        var result = ""
        for str in strArray {
            result += capitalizeFirstLetter(ofString: str)
            result += " "
        }
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        return result
    }
    
    class func capitalizeFirstLetter(ofString: String) -> String {
        let first = String(ofString.characters.prefix(1)).capitalized
        let other = String(ofString.characters.dropFirst())
        return first + other
    }
}
