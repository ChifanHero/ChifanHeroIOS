//
//  TextUtil.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/19/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class TextUtil {
    class func getReviewTimeText(_ time: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let date: Date? = dateFormatter.date(from: time)
        if date != nil {
            let calender: Calendar = Calendar.current
            let components = calender.dateComponents(in: TimeZone.autoupdatingCurrent, from: date!)
            let currentComponets = calender.dateComponents(in: TimeZone.autoupdatingCurrent, from: Date())
            var timeString = ""
            let year = components.year
            let currentYear = currentComponets.year
            let month = components.month
            let currentMonth = currentComponets.month
            let day = components.day
            let currentDay = currentComponets.day
            
            if year == currentYear {
                if month == currentMonth {
                    if day == currentDay {
                        timeString = "今天"
                    } else if currentDay! - day! <= 5 {
                        timeString = "\(currentDay! - day!)天前"
                    } else {
                        timeString = "\(month!)月\(day!)日"
                    }
                    
                } else {
                    timeString = "\(month!)月\(day!)日"
                }
            } else {
                timeString = "\(year!)年\(month!)月\(day!)日"
            }
            return timeString
        }
        return "未知时间"
    }
    
    class func getLocationServicePromptText() -> String {
        return "允许位置服务，吃饭英雄会给您带来更好的使用体验。"
    }
    
    class func getTextWhenUserTurnOffLocationService(city: String) -> String {
        return "您已关闭位置服务\n当前城市为：\(city)。"
    }
}
