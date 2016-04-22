//
//  TutorialViewController.swift
//  Lightning
//
//  Created by Shi Yan on 2/26/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageController : UIPageViewController?

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageController!.dataSource = self
        self.pageController!.view.frame = self.view.bounds
        let initialViewController : TutorialChildViewController = self.viewControllerAtIndex(0)
        let viewControllers = [initialViewController]
        self.pageController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController!.didMoveToParentViewController(self)
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.skipButton)

        // Do any additional setup after loading the view.
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

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc : TutorialChildViewController = viewController as! TutorialChildViewController
        var index = vc.index
        self.pageControl.currentPage = index
        if index == 0 {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc : TutorialChildViewController = viewController as! TutorialChildViewController
        var index = vc.index
        self.pageControl.currentPage = index
        if index == 4 {
            return nil
        }
        index += 1
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index : Int) -> TutorialChildViewController{
        let childViewController = TutorialChildViewController()
        childViewController.index = index
        return childViewController
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 5
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }

}
