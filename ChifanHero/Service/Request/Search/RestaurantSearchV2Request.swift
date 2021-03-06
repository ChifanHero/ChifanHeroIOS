//
//  RestaurantSearchV2Request.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class RestaurantSearchV2Request: HttpRequest{
    
    var keyword: String?
    var rating: Float?
    var range: Range?
    var order: String?
    var open: OpenEnum?
    
    override func getRelativeURL() -> String {
        if keyword == nil {
            return constructNearBySearchApi()
        } else {
            return constructTextSearchApi()
        }
    }
    
    private func constructNearBySearchApi() -> String {
        var result = "/nearBy?"
        if let radius = range?.distance?.value {
            result += "radius="
            result += String(Int(radius * 1.6 * 1000))
        }
        result += "&location.lat=" + String(range?.center?.lat ?? 37.2784)
        result += "&location.lon=" + String(range?.center?.lon ?? -121.9475)
        result += "&rating=" + String(rating ?? 1.0)
        result += "&sortOrder=" + (order ?? "best_match")
        if open != nil && open == OpenEnum.openNow {
            result += "&opennow=true"
        }
        return result
    }
    
    private func constructTextSearchApi() -> String {
        var result = "/text?"
        if let radius = range?.distance?.value {
            result += "radius="
            result += String(Int(radius * 1.6 * 1000))
        }
        result += "&location.lat=" + String(range?.center?.lat ?? 37.2784)
        result += "&location.lon=" + String(range?.center?.lon ?? -121.9475)
        result += "&rating=" + String(rating ?? 1.0)
        result += "&query=" + keyword!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        result += "&sortOrder=" + (order ?? "best_match")
        if open != nil && open == OpenEnum.openNow {
            result += "&opennow=true"
        }
        return result
    }
}
