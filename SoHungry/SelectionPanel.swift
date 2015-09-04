//
//  SelectionPanel.swift
//  SoHungry
//
//  Created by Shi Yan on 9/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SelectionPanel: UIView {
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var boarderColor : UIColor = UIColor.orangeColor()
    @IBInspectable var leadingSpace : CGFloat = 10
    @IBInspectable var font : UIFont = UIFont.systemFontOfSize(17)
    @IBInspectable var labelToBoarderHorizontalSpace : CGFloat = 5
    @IBInspectable var labelToBoarderVerticalSpace : CGFloat = 5
    
    
    private var options : [UILabel] = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        self.backgroundColor = UIColor.redColor()
    }
    
    func setUpSelectionPanel(options options : [String], var defaultSelection : Int?) {
        
        if (options.count <= 0) {
            return
        }
        
        for var i = 0; i < options.count; i++ {
            let label : UILabel = UILabel()
            label.text = options[i]
            label.font = font
            label.sizeToFit()
            let labelWidth : CGFloat = label.frame.size.width
            let labelHeight : CGFloat = label.frame.size.height
            label.frame = CGRectMake(labelToBoarderHorizontalSpace, labelToBoarderVerticalSpace, labelWidth, labelHeight)
            self.options.append(label)
            
        }        
        let space : CGFloat = getElementsSpace()
        
        var x = leadingSpace
        for var j = 0; j < self.options.count; j++ {
            
            let containerView = UIView()
            containerView.alpha = 1
            let containerViewHeight = self.options[j].frame.size.height + 2 * labelToBoarderVerticalSpace
            let containerViewWidth = self.options[j].frame.size.width + 2 * labelToBoarderHorizontalSpace
            let y = (self.frame.height - containerViewHeight) / 2
            containerView.frame = CGRectMake(x, y, containerViewWidth, containerViewHeight)
            containerView.tag = j
            x = x + containerView.frame.size.width + space
            
            containerView.layer.cornerRadius = 5
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.blackColor().CGColor
            
            if defaultSelection == nil || defaultSelection! < 0 && defaultSelection >= self.options.count {
                defaultSelection = 0
            }
            if j == defaultSelection {
                containerView.layer.borderWidth = 1
            }
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleElementTap:")
            containerView.addGestureRecognizer(tapGesture)
            
            
            containerView.addSubview(self.options[j])
            self.addSubview(containerView)
            
            
        }
        
    }
    
    private func getElementsSpace() -> CGFloat {
        let totalWidth = self.frame.size.width
        var widthTakenByElement : CGFloat = 0
        for option in self.options {
            widthTakenByElement = widthTakenByElement + option.frame.size.width + 2 * labelToBoarderHorizontalSpace
        }
        let space : CGFloat = (totalWidth - leadingSpace * 2 - widthTakenByElement) / CGFloat(((self.options.count) - 1))
        return space
    }
    
    @objc private func handleElementTap(recognizer: UITapGestureRecognizer) {
        print("tapped")
    }

}
