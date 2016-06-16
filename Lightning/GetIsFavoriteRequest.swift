//
//  GetIsFavoriteRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetIsFavoriteRequest: HttpRequest{
    
    var favoriteType: String
    var id: String
    
    init(type: FavoriteTypeEnum, id: String){
        if type == FavoriteTypeEnum.Restaurant{
            self.favoriteType = "restaurant"
        } else if type == .Dish {
            self.favoriteType = "dish"
        } else {
            self.favoriteType = "selected_collection"
        }
        self.id = id
    }
    
    override func getRelativeURL() -> String {
        return "/isFavorite?type=" + favoriteType + "&id=" + id
    }
}