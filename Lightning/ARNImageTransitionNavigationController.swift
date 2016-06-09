//
//  ARNImageTransitionNavigationController.swift
//  ARNZoomImageTransition
//
//  Created by xxxAIRINxxx on 2015/08/08.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

class ARNImageTransitionNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    weak var interactiveAnimator: ARNTransitionAnimator?
    var currentOperation: UINavigationControllerOperation = .None
    let expandingCellTransition = ExpandingCellTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.enabled = false
        self.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        if fromVC is RestaurantCollectionMembersViewController{
            if operation == .Push{
                if let transitionSource = fromVC as? ARNImageTransitionZoomable {
                    if transitionSource.usingAnimatedTransition() {
                        self.currentOperation = operation
                        return ARNImageZoomTransition.createAnimator(.Push, fromVC: fromVC, toVC: toVC)
                    }
                }
            } else if operation == .Pop {
                expandingCellTransition.operation = operation
                expandingCellTransition.duration = 0.80
                return expandingCellTransition
            }
        } else if let transitionSource = fromVC as? SelectedCollectionsTableViewController {
            if operation == .Push {
                expandingCellTransition.operation = UINavigationControllerOperation.Push
                expandingCellTransition.duration = 0.80
                expandingCellTransition.selectedCellFrame = transitionSource.selectedCellFrame
                
                return expandingCellTransition
            } else {
                return nil
            }
        } else if let transitionSource = fromVC as? ARNImageTransitionZoomable {
            if transitionSource.usingAnimatedTransition() {
                self.currentOperation = operation
                
                if operation == .Push {
                    return ARNImageZoomTransition.createAnimator(.Push, fromVC: fromVC, toVC: toVC)
                } else if operation == .Pop {
                    return ARNImageZoomTransition.createAnimator(.Pop, fromVC: fromVC, toVC: toVC)
                }
            }
        }
        return nil
    }

}
