//
//  ARNImageTransitionNavigationController.swift
//  ARNZoomImageTransition
//
//  Created by xxxAIRINxxx on 2015/08/08.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit


class ARNImageTransitionNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    weak var interactiveAnimator: ARNTransitionAnimator?
    var currentOperation: UINavigationControllerOperation = .none
    let expandingCellTransition = ExpandingCellTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if toVC is SelectedCollectionsTableViewController && !(fromVC is RestaurantCollectionMembersViewController){
            return nil
        }
        
        if fromVC is RestaurantCollectionMembersViewController{
            if operation == .push{
                if let transitionSource = fromVC as? ARNImageTransitionZoomable {
                    if transitionSource.usingAnimatedTransition() {
                        self.currentOperation = operation
                        return ARNImageZoomTransition.createAnimator(.push, fromVC: fromVC, toVC: toVC)
                    }
                }
            } else if operation == .pop {
                expandingCellTransition.operation = operation
                expandingCellTransition.duration = 0.80
                return expandingCellTransition
            }
        } else if let transitionSource = fromVC as? SelectedCollectionsTableViewController {
            if operation == .push {
                expandingCellTransition.operation = UINavigationControllerOperation.push
                expandingCellTransition.duration = 0.80
                expandingCellTransition.selectedCellFrame = transitionSource.selectedCellFrame
                
                return expandingCellTransition
            } else {
                return nil
            }
        } else if let transitionSource = fromVC as? ARNImageTransitionZoomable {
            if transitionSource.usingAnimatedTransition() {
                self.currentOperation = operation
                
                if operation == .push {
                    return ARNImageZoomTransition.createAnimator(.push, fromVC: fromVC, toVC: toVC)
                } else if operation == .pop {
                    if let identifiableSource = fromVC as? ARNImageTransitionIdentifiable, let identifiableDestination = toVC as? ARNImageTransitionIdentifiable {
                        if (identifiableSource.getDirectAncestorId() == identifiableDestination.getId()) {
                            return ARNImageZoomTransition.createAnimator(.pop, fromVC: fromVC, toVC: toVC)
                        } else {
                            return nil
                        }
                    } else {
                        return ARNImageZoomTransition.createAnimator(.pop, fromVC: fromVC, toVC: toVC)
                    }
                    
                }
            }
        }
        return nil
    }

}
