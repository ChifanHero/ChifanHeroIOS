//
//  RetryButton.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/7/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class RetryButton: UIButton {
    
    private var countDown: Bool = true
    private var countDownSeconds: Int = 10
    var touchDownEvent: (() -> Void) = {}
    
    private var secondsRemaining: Int = 10
    
    private var normalBackgroundColor: UIColor = .themeOrange()
    private var normalText: String = ""
    private var normalTextColor: UIColor = .white
    private var normalTextSize: Int = 14
    
    private var waitingBackgroundColor: UIColor = .gray
    private var waitingText: String = ""
    private var waitingTextColor: UIColor = .white
    private var waitingTextSize: Int = 14
    
    private var timer: Timer?
    
    var isWaiting = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.layer.cornerRadius = CGFloat(3)
        self.addTarget(self, action: #selector(RetryButton.touchDown), for: UIControlEvents.touchDown)
    }
    
    func setNormalState(text: String, color: UIColor?, size: Int?, backgroundColor: UIColor?) {
        if (backgroundColor != nil) {
            normalBackgroundColor = backgroundColor!
        }
        normalText = text
        reset()
    }
    
    func setWaitingState(text: String, color: UIColor?, size: Int?, backgroundColor: UIColor?) {
        if (backgroundColor != nil) {
            waitingBackgroundColor = backgroundColor!
        }
        waitingText = text
    }
    
    func setCountdown(enabled: Bool, seconds: Int?) {
        countDown = enabled
        if seconds != nil {
            countDownSeconds = seconds!
            secondsRemaining = seconds!
        }
    }
    
    func enterTempState(text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(normalTextColor, for: .normal)
        self.isUserInteractionEnabled = false
    }
    
    func endTempState() {
        self.setTitle(normalText, for: .normal)
        self.setTitleColor(normalTextColor, for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        self.backgroundColor = UIColor.gray
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.backgroundColor = normalBackgroundColor
        self.isUserInteractionEnabled = true
    }
    
    func touchDown() {
        touchDownEvent()
    }
    
    func startWaiting() {
        self.isWaiting = true
        self.setTitleColor(waitingTextColor, for: .disabled)
        self.backgroundColor = waitingBackgroundColor
        self.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func update() {
        if (secondsRemaining == 0) {
            reset()
        } else {
            let text = waitingText + "(" + String(secondsRemaining) + ")"
            self.setTitle(text, for: .disabled)
            secondsRemaining = secondsRemaining - 1
        }
    }
    
    func reset() {
        isWaiting = false
        timer?.invalidate()
        self.setTitle(normalText, for: .normal)
        self.setTitleColor(normalTextColor, for: .normal)
        self.backgroundColor = normalBackgroundColor
        self.isEnabled = true
        self.isUserInteractionEnabled = true
        secondsRemaining = countDownSeconds
    }

}
