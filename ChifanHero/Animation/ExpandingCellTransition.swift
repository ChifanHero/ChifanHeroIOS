import Foundation
import UIKit

class ExpandingCellTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    var operation: UINavigationControllerOperation?
    
    var imageViewTop: UIImageView?
    var imageViewBottom: UIImageView?
    var duration: TimeInterval = 0
    var selectedCellFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let sourceVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let sourceView = sourceVC.view
        
        let destinationVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let destinationView = destinationVC.view
        
        // MARK:
        if let navController = destinationVC.navigationController {
            for constraint in destinationVC.view.constraints as [NSLayoutConstraint] {
                if constraint.firstItem === destinationVC.topLayoutGuide
                    && constraint.firstAttribute == .height
                    && constraint.secondItem == nil
                    && constraint.constant == 0 {
                    constraint.constant = navController.navigationBar.frame.height
                }
            }
        }
        
        let container = transitionContext.containerView
        
        self.selectedCellFrame = CGRect(x: self.selectedCellFrame.origin.x, y: self.selectedCellFrame.origin.y + self.selectedCellFrame.height, width: self.selectedCellFrame.width, height: self.selectedCellFrame.height)
        
        var snapShot = UIImage()
        let bounds = CGRect(x: 0, y: 0, width: (sourceView?.bounds.size.width)!, height: (sourceView?.bounds.size.height)!)
        
        if self.operation == UINavigationControllerOperation.push {
            UIGraphicsBeginImageContextWithOptions((sourceView?.bounds.size)!, true, 0)
            
            sourceView?.drawHierarchy(in: bounds, afterScreenUpdates: false)
            
            snapShot = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            let tempImageRef = snapShot.cgImage!
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
            
            let topImageRect = CGRect(x: 0, y: 0, width: imageSize.width * imageScale, height: topHeight)
            
            let bottomImageRect = CGRect(x: 0, y: topHeight, width: imageSize.width * imageScale, height: bottomHeight)
            let topImageRef = tempImageRef.cropping(to: topImageRect)!
            let bottomImageRef = tempImageRef.cropping(to: bottomImageRect)
            
            self.imageViewTop = UIImageView(image: UIImage(cgImage: topImageRef, scale: snapShot.scale, orientation: UIImageOrientation.up))
            
            if (bottomImageRef != nil) {
                self.imageViewBottom = UIImageView(image: UIImage(cgImage: bottomImageRef!, scale: snapShot.scale, orientation: UIImageOrientation.up))
            }
        }
        
        
        
        var startFrameTop = self.imageViewTop!.frame
        var endFrameTop = startFrameTop
        var startFrameBottom = self.imageViewBottom!.frame
        var endFrameBottom = startFrameBottom
        
        if self.operation == UINavigationControllerOperation.pop {
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
        
        destinationView?.alpha = 1
        sourceView?.alpha = 1
        
        //let backgroundView = UIView(frame: bounds)
        //backgroundView.backgroundColor = UIColor.blackColor()
        
        if self.operation == UINavigationControllerOperation.pop {
            sourceView?.alpha = 1
            destinationView?.alpha = 0
            
            //container.addSubview(backgroundView)
            container.addSubview(sourceView!)
            container.addSubview(destinationView!)
            container.addSubview(self.imageViewTop!)
            container.addSubview(self.imageViewBottom!)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                self.imageViewTop!.frame = endFrameTop
                self.imageViewBottom!.frame = endFrameBottom
                
                sourceView?.alpha = 0
                
                }, completion: { (finish) -> Void in
                    self.imageViewTop!.removeFromSuperview()
                    self.imageViewBottom!.removeFromSuperview()
                    
                    destinationView?.alpha = 1
                    transitionContext.completeTransition(true)
            })
            
        } else {
            //container.addSubview(backgroundView)
            container.addSubview(destinationView!)
            container.addSubview(self.imageViewTop!)
            container.addSubview(self.imageViewBottom!)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                self.imageViewTop!.frame = endFrameTop
                self.imageViewBottom!.frame = endFrameBottom
                
                destinationView?.alpha = 1
                
                }, completion: { (finish) -> Void in
                    self.imageViewTop!.removeFromSuperview()
                    self.imageViewBottom!.removeFromSuperview()
                    
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
