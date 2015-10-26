//
//  FloatingBubbleBehavior.swift
//  SoHungry
//
//  Created by Shi Yan on 10/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit


class FloatingBehavior: UIDynamicBehavior {
    // MARK: Properties
    
    private let itemBehavior: UIDynamicItemBehavior
    
    private let collisionBehavior: UICollisionBehavior
    
    private let item: UIDynamicItem
    
    private var fieldBehavior : UIFieldBehavior
    
    // Enabling/disabling effectively adds or removes the item from the child behaviors.
    var isEnabled = true {
        didSet {
            if isEnabled {
                fieldBehavior.addItem(item)
                collisionBehavior.addItem(item)
                itemBehavior.addItem(item)
            }
            else {
                fieldBehavior.removeItem(item)
                collisionBehavior.removeItem(item)
                itemBehavior.removeItem(item)
            }
        }
    }
    
    // MARK: Initializers
    
    init(item: UIDynamicItem) {
        self.item = item
        // Setup a collision behavior so the item cannot escape the screen.
        collisionBehavior = UICollisionBehavior(items: [item])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        itemBehavior = UIDynamicItemBehavior(items: [item])
        itemBehavior.resistance = 0.2
        itemBehavior.density = 3.0
        itemBehavior.allowsRotation = false
        
        fieldBehavior = UIFieldBehavior.dragField()
        fieldBehavior.addItem(item)
        
        super.init()
        
        // Add each behavior as a child behavior.
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        addChildBehavior(fieldBehavior)
    }
    
    // MARK: UIDynamicBehavior
    
    override func willMoveToAnimator(dynamicAnimator: UIDynamicAnimator?) {
        super.willMoveToAnimator(dynamicAnimator)
        guard let bounds = dynamicAnimator?.referenceView?.bounds else { return }
        setupFieldBehavior(bounds)
    }
    
    func setupFieldBehavior(bounds: CGRect) {
        if bounds != CGRect.zero {
            fieldBehavior.position = CGPointMake(bounds.midX, bounds.midY)
            fieldBehavior.region = UIRegion(size: bounds.size)
        }
    }
    
    func addLinearVelocity(velocity: CGPoint) {
        itemBehavior.addLinearVelocity(velocity, forItem: item)
    }
}
