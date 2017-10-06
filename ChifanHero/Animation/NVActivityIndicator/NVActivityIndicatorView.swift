//
//  NVActivityIndicatorView.swift
//  NVActivityIndicatorViewDemo
//
//  Created by Nguyen Vinh on 7/21/15.
//  Copyright (c) 2015 Nguyen Vinh. All rights reserved.
//

import UIKit

/**
 Enum of animation types used for activity indicator view.
 
 - Blank:                   Blank animation.
 - BallPulse:               BallPulse animation.
 - BallGridPulse:           BallGridPulse animation.
 - BallClipRotate:          BallClipRotate animation.
 - SquareSpin:              SquareSpin animation.
 - BallClipRotatePulse:     BallClipRotatePulse animation.
 - BallClipRotateMultiple:  BallClipRotateMultiple animation.
 - BallPulseRise:           BallPulseRise animation.
 - BallRotate:              BallRotate animation.
 - CubeTransition:          CubeTransition animation.
 - BallZigZag:              BallZigZag animation.
 - BallZigZagDeflect:       BallZigZagDeflect animation.
 - BallTrianglePath:        BallTrianglePath animation.
 - BallScale:               BallScale animation.
 - LineScale:               LineScale animation.
 - LineScaleParty:          LineScaleParty animation.
 - BallScaleMultiple:       BallScaleMultiple animation.
 - BallPulseSync:           BallPulseSync animation.
 - BallBeat:                BallBeat animation.
 - LineScalePulseOut:       LineScalePulseOut animation.
 - LineScalePulseOutRapid:  LineScalePulseOutRapid animation.
 - BallScaleRipple:         BallScaleRipple animation.
 - BallScaleRippleMultiple: BallScaleRippleMultiple animation.
 - BallSpinFadeLoader:      BallSpinFadeLoader animation.
 - LineSpinFadeLoader:      LineSpinFadeLoader animation.
 - TriangleSkewSpin:        TriangleSkewSpin animation.
 - Pacman:                  Pacman animation.
 - BallGridBeat:            BallGridBeat animation.
 - SemiCircleSpin:          SemiCircleSpin animation.
 - BallRotateChase:         BallRotateChase animation.
 */
public enum NVActivityIndicatorType: Int {
    /**
     Blank.
     
     - returns: Instance of NVActivityIndicatorAnimationBlank.
     */
    case blank
    /**
     BallPulse.
     
     - returns: Instance of NVActivityIndicatorAnimationBallPulse.
     */
    case ballPulse
    /**
     BallGridPulse.
     
     - returns: Instance of NVActivityIndicatorAnimationBallGridPulse.
     */
    case ballGridPulse
    /**
     BallClipRotate.
     
     - returns: Instance of NVActivityIndicatorAnimationBallClipRotate.
     */
    case ballClipRotate
    /**
     SquareSpin.
     
     - returns: Instance of NVActivityIndicatorAnimationSquareSpin.
     */
    case squareSpin
    /**
     BallClipRotatePulse.
     
     - returns: Instance of NVActivityIndicatorAnimationBallClipRotatePulse.
     */
    case ballClipRotatePulse
    /**
     BallClipRotateMultiple.
     
     - returns: Instance of NVActivityIndicatorAnimationBallClipRotateMultiple.
     */
    case ballClipRotateMultiple
    /**
     BallPulseRise.
     
     - returns: Instance of NVActivityIndicatorAnimationBallPulseRise.
     */
    case ballPulseRise
    /**
     BallRotate.
     
     - returns: Instance of NVActivityIndicatorAnimationBallRotate.
     */
    case ballRotate
    /**
     CubeTransition.
     
     - returns: Instance of NVActivityIndicatorAnimationCubeTransition.
     */
    case cubeTransition
    /**
     BallZigZag.
     
     - returns: Instance of NVActivityIndicatorAnimationBallZigZag.
     */
    case ballZigZag
    /**
     BallZigZagDeflect
     
     - returns: Instance of NVActivityIndicatorAnimationBallZigZagDeflect
     */
    case ballZigZagDeflect
    /**
     BallTrianglePath.
     
     - returns: Instance of NVActivityIndicatorAnimationBallTrianglePath.
     */
    case ballTrianglePath
    /**
     BallScale.
     
     - returns: Instance of NVActivityIndicatorAnimationBallScale.
     */
    case ballScale
    /**
     LineScale.
     
     - returns: Instance of NVActivityIndicatorAnimationLineScale.
     */
    case lineScale
    /**
     LineScaleParty.
     
     - returns: Instance of NVActivityIndicatorAnimationLineScaleParty.
     */
    case lineScaleParty
    /**
     BallScaleMultiple.
     
     - returns: Instance of NVActivityIndicatorAnimationBallScaleMultiple.
     */
    case ballScaleMultiple
    /**
     BallPulseSync.
     
     - returns: Instance of NVActivityIndicatorAnimationBallPulseSync.
     */
    case ballPulseSync
    /**
     BallBeat.
     
     - returns: Instance of NVActivityIndicatorAnimationBallBeat.
     */
    case ballBeat
    /**
     LineScalePulseOut.
     
     - returns: Instance of NVActivityIndicatorAnimationLineScalePulseOut.
     */
    case lineScalePulseOut
    /**
     LineScalePulseOutRapid.
     
     - returns: Instance of NVActivityIndicatorAnimationLineScalePulseOutRapid.
     */
    case lineScalePulseOutRapid
    /**
     BallScaleRipple.
     
     - returns: Instance of NVActivityIndicatorAnimationBallScaleRipple.
     */
    case ballScaleRipple
    /**
     BallScaleRippleMultiple.
     
     - returns: Instance of NVActivityIndicatorAnimationBallScaleRippleMultiple.
     */
    case ballScaleRippleMultiple
    /**
     BallSpinFadeLoader.
     
     - returns: Instance of NVActivityIndicatorAnimationBallSpinFadeLoader.
     */
    case ballSpinFadeLoader
    /**
     LineSpinFadeLoader.
     
     - returns: Instance of NVActivityIndicatorAnimationLineSpinFadeLoader.
     */
    case lineSpinFadeLoader
    /**
     TriangleSkewSpin.
     
     - returns: Instance of NVActivityIndicatorAnimationTriangleSkewSpin.
     */
    case triangleSkewSpin
    /**
     Pacman.
     
     - returns: Instance of NVActivityIndicatorAnimationPacman.
     */
    case pacman
    /**
     BallGridBeat.
     
     - returns: Instance of NVActivityIndicatorAnimationBallGridBeat.
     */
    case ballGridBeat
    /**
     SemiCircleSpin.
     
     - returns: Instance of NVActivityIndicatorAnimationSemiCircleSpin.
     */
    case semiCircleSpin
    /**
     BallRotateChase.
     
     - returns: Instance of NVActivityIndicatorAnimationBallRotateChase.
     */
    case ballRotateChase
    
    fileprivate static let allTypes = (blank.rawValue ... ballRotateChase.rawValue).map{ NVActivityIndicatorType(rawValue: $0)! }
    
    fileprivate func animation() -> NVActivityIndicatorAnimationDelegate {
        switch self {
//        case .Blank:
//            return NVActivityIndicatorAnimationBlank()
//        case .BallPulse:
//            return NVActivityIndicatorAnimationBallPulse()
//        case .BallGridPulse:
//            return NVActivityIndicatorAnimationBallGridPulse()
//        case .BallClipRotate:
//            return NVActivityIndicatorAnimationBallClipRotate()
//        case .SquareSpin:
//            return NVActivityIndicatorAnimationSquareSpin()
//        case .BallClipRotatePulse:
//            return NVActivityIndicatorAnimationBallClipRotatePulse()
//        case .BallClipRotateMultiple:
//            return NVActivityIndicatorAnimationBallClipRotateMultiple()
//        case .BallPulseRise:
//            return NVActivityIndicatorAnimationBallPulseRise()
//        case .BallRotate:
//            return NVActivityIndicatorAnimationBallRotate()
//        case .CubeTransition:
//            return NVActivityIndicatorAnimationCubeTransition()
//        case .BallZigZag:
//            return NVActivityIndicatorAnimationBallZigZag()
//        case .BallZigZagDeflect:
//            return NVActivityIndicatorAnimationBallZigZagDeflect()
//        case .BallTrianglePath:
//            return NVActivityIndicatorAnimationBallTrianglePath()
//        case .BallScale:
//            return NVActivityIndicatorAnimationBallScale()
//        case .LineScale:
//            return NVActivityIndicatorAnimationLineScale()
//        case .LineScaleParty:
//            return NVActivityIndicatorAnimationLineScaleParty()
//        case .BallScaleMultiple:
//            return NVActivityIndicatorAnimationBallScaleMultiple()
//        case .BallPulseSync:
//            return NVActivityIndicatorAnimationBallPulseSync()
//        case .BallBeat:
//            return NVActivityIndicatorAnimationBallBeat()
//        case .LineScalePulseOut:
//            return NVActivityIndicatorAnimationLineScalePulseOut()
//        case .LineScalePulseOutRapid:
//            return NVActivityIndicatorAnimationLineScalePulseOutRapid()
//        case .BallScaleRipple:
//            return NVActivityIndicatorAnimationBallScaleRipple()
//        case .BallScaleRippleMultiple:
//            return NVActivityIndicatorAnimationBallScaleRippleMultiple()
        case .ballSpinFadeLoader:
            return NVActivityIndicatorAnimationBallSpinFadeLoader()
//        case .LineSpinFadeLoader:
//            return NVActivityIndicatorAnimationLineSpinFadeLoader()
//        case .TriangleSkewSpin:
//            return NVActivityIndicatorAnimationTriangleSkewSpin()
        case .pacman:
            return NVActivityIndicatorAnimationPacman()
//        case .BallGridBeat:
//            return NVActivityIndicatorAnimationBallGridBeat()
//        case .SemiCircleSpin:
//            return NVActivityIndicatorAnimationSemiCircleSpin()
//        case .BallRotateChase:
//            return NVActivityIndicatorAnimationBallRotateChase()
        default:
            return NVActivityIndicatorAnimationBallSpinFadeLoader()
        }
    }
}

/// Activity indicator view with nice animations
open class NVActivityIndicatorView: UIView {
    /// Default type. Default value is .BallSpinFadeLoader.
    open static var DEFAULT_TYPE: NVActivityIndicatorType = .ballSpinFadeLoader
    
    /// Default color. Default value is UIColor.whiteColor().
    open static var DEFAULT_COLOR = UIColor.white
    
    /// Default padding. Default value is 0.
    open static var DEFAULT_PADDING: CGFloat = 0
    
    /// Animation type, value of NVActivityIndicatorType enum.
    open var type: NVActivityIndicatorType = NVActivityIndicatorView.DEFAULT_TYPE
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'type' instead.")
    @IBInspectable var typeName: String {
        get {
            return String(describing: self.type)
        }
        set (typeString) {
            for item in NVActivityIndicatorType.allTypes {
                if String(describing: item).caseInsensitiveCompare(typeString) == ComparisonResult.orderedSame {
                    self.type = item
                    break
                }
            }
        }
    }
    
    /// Color of activity indicator view.
    @IBInspectable open var color: UIColor = NVActivityIndicatorView.DEFAULT_COLOR
    
    /// Padding of activity indicator view.
    @IBInspectable open var padding: CGFloat = NVActivityIndicatorView.DEFAULT_PADDING
    
    /// Current status of animation, this is not used to start or stop animation.
    open var animating: Bool = false
    
    /// Specify whether activity indicator view should hide once stopped.
    @IBInspectable open var hidesWhenStopped: Bool = true
    
    /**
     Create a activity indicator view with default type, color and padding.
     This is used by storyboard to initiate the view.
     
     - Default type is BallSpinFadeLoader.
     - Default color is white.
     - Default padding is 0.
     
     - parameter decoder:
     
     - returns: The activity indicator view.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    /**
     Create a activity indicator view with specified frame, type, color and padding.
     
     - parameter frame: view's frame.
     - parameter type: animation type, value of NVActivityIndicatorType enum. Default type is BallSpinFadeLoader.
     - parameter color: color of activity indicator view. Default color is white.
     - parameter padding: view's padding. Default padding is 0.
     
     - returns: The activity indicator view.
     */
    public init(frame: CGRect, type: NVActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.type = type ?? NVActivityIndicatorView.DEFAULT_TYPE
        self.color = color ?? NVActivityIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? NVActivityIndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
    }
    
    /**
     Start animation.
     */
    open func startAnimation() {
        if hidesWhenStopped && isHidden {
            isHidden = false
        }
        if (self.layer.sublayers == nil) {
            setUpAnimation()
        }
        self.layer.speed = 1
        self.animating = true
    }
    
    /**
     Stop animation.
     */
    open func stopAnimation() {
        self.layer.sublayers = nil
        self.animating = false
        if hidesWhenStopped && !isHidden {
            isHidden = true
        }
    }
    
    // MARK: Privates
    
    fileprivate func setUpAnimation() {
        let animation: NVActivityIndicatorAnimationDelegate = self.type.animation()
        var animationRect = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        self.layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimationInLayer(self.layer, size: animationRect.size, color: self.color)
    }
}
