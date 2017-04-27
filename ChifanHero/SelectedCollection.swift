//
//  SelectedCollection.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class SelectedCollection: Model{
    
    var id: String?
    var title: String?
    var description: String?
    var typeId: Int?
    var memberCount: Int?
    var likeCount: Int?
    var userFavoriteCount: Int?
    var cellImage: Picture?
    var coverageCenterGeo: Location?
    var coverageRadius: Int?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        id = data["id"].string
        title = data["title"].string
        description = data["description"].string
        typeId = data["type_id"].int
        memberCount = data["member_count"].int
        likeCount = data["like_count"].int
        userFavoriteCount = data["user_favorite_count"].int
        if(data["cell_image"].exists()){
            cellImage = Picture(data: data["cell_image"])
        }
        if(data["coverage_center_geo"].exists()){
            coverageCenterGeo = Location(data: data["coverage_center_geo"])
        }
        coverageRadius = data["coverage_radius"].int
    }
}
