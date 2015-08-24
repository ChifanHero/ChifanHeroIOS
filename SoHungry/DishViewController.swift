//
//  DishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {
    
    var dishId : String?
    
    var dish : Dish?

    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        if (dishId != nil) {
            let request : GetDishByIdRequest = GetDishByIdRequest(id: dishId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getDishById(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.dish = (response?.result)!
                    if self.dish != nil {
                        self.topViewContainer.name = self.dish?.name
                        self.topViewContainer.englishName = self.dish?.englishName
                        self.topViewContainer.backgroundImageURL = self.dish?.picture?.original
                    }
                });
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
