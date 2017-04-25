//
//  NSDateExtension.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

extension Date {
    
    func toISO8601() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    
    init(dateString : String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        dateStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateStringFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: d)
    }
}
