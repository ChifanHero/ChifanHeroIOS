//
//  SearchContext.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class SearchContext {
    
    static var keyword: String? {
        didSet {
            newSearch = true
        }
    }
    static var newSearch: Bool = false
    static var sort : SortOptions = SortOptions.bestmatch {
        didSet {
            newSearch = true
        }
    }
    static var distance: RangeFilter = RangeFilter.twenty {
        didSet {
            newSearch = true
        }
    }
    static var rating: RatingFilter = RatingFilter.four {
        didSet {
            newSearch = true
        }
    }
    static var address: String? {
        didSet {
            newSearch = true
        }
    }
    static var coordinates: Location? {
        didSet {
            newSearch = true
        }
    }
    static var open: OpenEnum = OpenEnum.all {
        didSet {
            newSearch = true
        }
    }
}
