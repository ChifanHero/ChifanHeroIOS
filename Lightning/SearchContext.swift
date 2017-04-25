//
//  SearchContext.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class SearchContext {
    
    var keyword : String? {
        didSet {
            newSearch = true
        }
    }
    var newSearch : Bool = false
    var sort : SortOptions = SortOptions.bestmatch {
        didSet {
            newSearch = true
        }
    }
    var distance : RangeFilter = RangeFilter.twenty {
        didSet {
            newSearch = true
        }
    }
    var rating : RatingFilter = RatingFilter.four {
        didSet {
            newSearch = true
        }
    }
    var address : String? {
        didSet {
            newSearch = true
        }
    }
    var coordinates : Location? {
        didSet {
            newSearch = true
        }
    }
    
    var offSet : Int? {
        didSet {
            newSearch = true
        }
    }
    
    var limit : Int = 25
}
