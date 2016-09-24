import Foundation
import UIKit

class ExpandingCellTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    var operation: UINavigationControllerOperation?
    
    var imageViewTop: UIImageView?
    var imageViewBottom: UIImageView?
    var duration: NSTimeInterval = 0
    var selectedCellFrame = CGRectZero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let sourceVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let sourceView = sourceVC.view
        
        let destinationVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let destinationView = destinationVC.view
        
        // MARK:
        if let navController = destinationVC.navigationController {
            for constraint in destinationVC.view.constraints as [NSLayoutConstraint] {
                if constraint.firstItem === destinationVC.topLayoutGuide
                    && constraint.firstAttribute == .Height
                    && constraint.secondItem == nil
                    && constraint.constant == 0 {
                    constraint.constant = navController.navigationBar.frame.height
                }
            }
        }
        
        let container = transitionContext.containerView()
        
        self.selectedCellFrame = CGRectMake(self.selectedCellFrame.origin.x, self.selectedCellFrame.origin.y + self.selectedCellFrame.height, self.selectedCellFrame.width, self.selectedCellFrame.height)
        
        var snapShot = UIImage()
        let bounds = CGRectMake(0, 0, sourceView.bounds.size.width, sourceView.bounds.size.height)
        
        if self.operation == UINavigationControllerOperation.Push {
            UIGraphicsBeginImageContextWithOptions(sourceView.bounds.size, true, 0)
            
            sourceView.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
            
            snapShot = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            let tempImageRef = snapShot.CGImage!
            let imageSize = snapShot.size
            let imageScale = snapShot.scale
            
            let midPoint = bounds.height / 2
            let selectedFrame = self.selectedCellFrame.origin.y - (self.selectedCellFrame.height / 2)
            
            let padding = self.selectedCellFrame.height * imageScale
            
            var topHeight: CGFloat = 0.0
            var bottomHeight: CGFloat = 0.0
            
            if selectedFrame < midPoint {
                topHeight = self.selectedCellFrame.origin.y * imageScale
                bottomHeight = (imageSize.height - self.selectedCellFrame.origin.y) * imageScale
            } else {
                topHeight = (self.selectedCellFrame.origin.y * imageScale) - padding
                bottomHeight = ((imageSize.height - self.selectedCellFrame.origin.y) * imageScale) + padding
            }
            
            let topImageRect = CGRectMake(0, 0, imageSize.width * imageScale, topHeight)
            
            let bottomImageRect = CGRectMake(0, topHeight, imageSize.width * imageScale, bottomHeight)
            let topImageRef = CGImageCreateWithImageInRect(tempImageRef, topImageRect)!
            let bottomImageRef = CGImageCreateWithImageInRect(tempImageRef, bottomImageRect)
            
            self.imageViewTop = UIImageView(image: UIImage(CGImage: topImageRef, scale: snapShot.scale, orientation: UIImageOrientation.Up))
            
            if (bottomImageRef != nil) {
                self.imageViewBottom = UIImageView(image: UIImage(CGImage: bottomImageRef!, scale: snapShot.scale, orientation: UIImageOrientation.Up))
            }
        }
        
        
        
        var startFrameTop = self.imageViewTop!.frame
        var endFrameTop = startFrameTop
        var startFrameBottom = self.imageViewBottom!.frame
        var endFrameBottom = startFrameBottom
        
        if self.operation == UINavigationControllerOperation.Pop {
            startFrameTop.origin.y = -startFrameTop.size.height
            endFrameTop.origin.y = 0
            startFrameBottom.origin.y = startFrameTop.height + startFrameBottom.height
            endFrameBottom.origin.y = startFrameTop.height
        } else {
            startFrameTop.origin.y = 0
            endFrameTop.origin.y = -startFrameTop.size.height
            startFrameBottom.origin.y = startFrameTop.size.height
            endFrameBottom.origin.y = startFrameTop.height + startFrameBottom.height
        }
        
        self.imageViewTop!.frame = startFrameTop
        self.imageViewBottom!.frame = startFrameBottom
        
        destinationView.alpha = 1
        sourceView.alpha = 1
        
        //let backgroundView = UIView(frame: bounds)
        //backgroundView.backgroundColor = UIColor.blackColor()
        
        if self.operation == UINavigationControllerOperation.Pop {
            sourceView.alpha = 1
            destinationView.alpha = 0
            
            //container.addSubview(backgroundView)
            container.addSubview(sourceView)
            container.addSubview(destinationView)
            container.addSubview(self.imageViewTop!)
            container.addSubview(self.imageViewBottom!)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                self.imageViewTop!.frame = endFrameTop
                self.imageViewBottom!.frame = endFrameBottom
                
                sourceView.alpha = 0
                
                }, completion: { (finish) -> Void in
                    self.imageViewTop!.removeFromSuperview()
                    self.imageViewBottom!.removeFromSuperview()
                    
                    destinationView.alpha = 1
                    transitionContext.completeTransition(true)
            })
            
        } else {
            //container.addSubview(backgroundView)
            container.addSubview(destinationView)
            container.addSubview(self.imageViewTop!)
            container.addSubview(self.imageViewBottom!)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                self.imageViewTop!.frame = endFrameTop
                self.imageViewBottom!.frame = endFrameBottom
                
                destinationView.alpha = 1
                
                }, completion: { (finish) -> Void in
                    self.imageViewTop!.removeFromSuperview()
                    self.imageViewBottom!.removeFromSuperview()
                    
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
