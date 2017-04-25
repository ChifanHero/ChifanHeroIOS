//
//  ARNImageZoomTransition.swift
//  ARNZoomImageTransition
//
//  Created by xxxAIRINxxx on 2015/08/08.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

@objc protocol ARNImageTransitionZoomable {
    
    func createTransitionImageView() -> UIImageView
    
    // Present, Push
    
    @objc optional
    func presentationBeforeAction()
    
    @objc optional
    func presentationAnimationAction(_ percentComplete: CGFloat)
    
    @objc optional
    func presentationCancelAnimationAction()
    
    @objc optional
    func presentationCompletionAction(_ completeTransition: Bool)
    
    // Dismiss, Pop
    
    @objc optional
    func dismissalBeforeAction()
    
    @objc optional
    func dismissalAnimationAction(_ percentComplete: CGFloat)
    
    @objc optional
    func dismissalCancelAnimationAction()
    
    @objc optional
    func dismissalCompletionAction(_ completeTransition: Bool)
    
    func usingAnimatedTransition() -> Bool
}

class ARNImageZoomTransition {
    
    class func createAnimator(_ operationType: ARNTransitionAnimatorOperation, fromVC: UIViewController, toVC: UIViewController) -> ARNTransitionAnimator {
        let animator = ARNTransitionAnimator(operationType: operationType, fromVC: fromVC, toVC: toVC)
        
        if let sourceTransition = fromVC as? ARNImageTransitionZoomable, let destinationTransition = toVC as? ARNImageTransitionZoomable {
            
            animator.presentationBeforeHandler = { [weak fromVC, weak toVC
                , weak sourceTransition, weak destinationTransition](containerView: UIView, transitionContext: UIViewControllerContextTransitioning) in
                containerView.addSubview(fromVC!.view)
                containerView.addSubview(toVC!.view)
                
                toVC!.view.layoutSubviews()
                toVC!.view.layoutIfNeeded()
                
                let sourceImageView = sourceTransition!.createTransitionImageView()
                let destinationImageView = destinationTransition!.createTransitionImageView()
                
                containerView.addSubview(sourceImageView)
                
                sourceTransition!.presentationBeforeAction?()
                destinationTransition!.presentationBeforeAction?()
                
                toVC!.view.alpha = 0.0
                
                animator.presentationAnimationHandler = { (containerView: UIView, percentComplete: CGFloat) in
                    sourceImageView.frame = destinationImageView.frame
                    
                    toVC!.view.alpha = 1.0
                    
                    sourceTransition!.presentationAnimationAction?(percentComplete)
                    destinationTransition!.presentationAnimationAction?(percentComplete)
                }
                
                animator.presentationCompletionHandler = { (containerView: UIView, completeTransition: Bool) in
                    sourceImageView.removeFromSuperview()
                    
                    sourceTransition!.presentationCompletionAction?(completeTransition)
                    destinationTransition!.presentationCompletionAction?(completeTransition)
                }
            }
            
            animator.dismissalBeforeHandler = { [weak fromVC, weak toVC
                , weak sourceTransition, weak destinationTransition] (containerView: UIView, transitionContext: UIViewControllerContextTransitioning) in
                containerView.addSubview(toVC!.view)
                containerView.bringSubview(toFront: fromVC!.view)
                
                let sourceImageView = sourceTransition!.createTransitionImageView()
                let destinationImageView = destinationTransition!.createTransitionImageView()
                containerView.addSubview(sourceImageView)
                
                sourceTransition!.dismissalBeforeAction?()
                destinationTransition!.dismissalBeforeAction?()
                
                animator.dismissalAnimationHandler = { (containerView: UIView, percentComplete: CGFloat) in
                    sourceImageView.frame = destinationImageView.frame
                    fromVC!.view.alpha = 0.0
                    
                    sourceTransition!.dismissalAnimationAction?(percentComplete)
                    destinationTransition!.dismissalAnimationAction?(percentComplete)
                }
                
                animator.dismissalCompletionHandler = { (containerView: UIView, completeTransition: Bool) in
                    sourceImageView.removeFromSuperview()
                    
                    sourceTransition!.dismissalCompletionAction?(completeTransition)
                    destinationTransition!.dismissalCompletionAction?(completeTransition)
                }
            }
        }
        
        return animator
    }
}
