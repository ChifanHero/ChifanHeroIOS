//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantAllDishViewController: UIViewController, SlideBarDelegate {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UISearchBar()
        super.viewDidLoad()
        slideBar.delegate = self
        slideBar.setUpScrollView(titles: ["全部","精美凉菜","主厨推荐","韶山经典","铁板干锅","石锅煲仔","私房蒸菜","特色小炒","健康美食","滋补汤羹","主食甜点"], defaultSelection: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    func slideBar(slideBar : SlideBar, didSelectElementAtIndex : Int) -> Void {
        
    }

}
