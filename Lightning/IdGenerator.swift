//
//  IdGenerator.swift
//  Lightning
//
//  Created by Shi Yan on 10/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class IdGenerator {
    
    
    static func newId() -> String{
        return randomString(20)
    }
    
    fileprivate static func randomString(_ size: Int) -> String{
        assert(size > 0)
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        var id = ""
        var bytes: [Int] = [Int]()
        for _ in 0..<size {
            bytes.append(Int(arc4random()))
        }
        for index in 0..<size {
            let charId: Int = UIntFromInt(bytes[index]) % chars.characters.count
            id.append(chars[chars.characters.index(chars.startIndex, offsetBy: charId)])
        }
        return id
    }
    
    fileprivate static func UIntFromInt(_ int: Int) -> Int{
        if int < 0 {
            return int + 256
        } else {
            return int
        }
        
    }
    
}
