//
//  GetFavoritesRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/13/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetFavoritesRequest: HttpRequest{
    
    var favoriteType: String
    var lat: Double?
    var lon: Double?
    
    init(type: FavoriteTypeEnum){
        if type == FavoriteTypeEnum.restaurant{
            self.favoriteType = "restaurant"
        } else if type == .dish {
            self.favoriteType = "dish"
        } else {
            self.favoriteType = "selected_collection"
        }
    }
    
    override func getRelativeURL() -> String {
        var url = "/favorites?type=" + favoriteType
        if lat != nil && lon != nil {
            url = url + "&lat=\(lat!)&lon=\(lon!)"
        }
        return url
    }
}
