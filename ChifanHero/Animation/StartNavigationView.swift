//
//  StartNavigationView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/10/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class StartNavigationView: UIView {
    
    let navigationLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let navigationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureSubviews()
        self.setUp()
    }
    
    private func configureSubviews() {
        self.navigationLogo.renderColorChangableImage(UIImage(named: "ChifanHero_NavigationArrow.png")!, fillColor: UIColor.themeOrange())
        self.navigationLogo.center.x = self.bounds.width / 4
        self.navigationLogo.center.y = self.bounds.height / 2
        
        self.navigationLabel.center.x = self.bounds.width / 2 + 10
        self.navigationLabel.center.y = self.bounds.height / 2
        self.navigationLabel.textAlignment = .center
        self.navigationLabel.text = "出发!"
        self.navigationLabel.textColor = UIColor.themeOrange()
        self.addSubview(navigationLogo)
        self.addSubview(navigationLabel)
    }
    
    private func setUp() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.themeOrange().cgColor
        self.layer.cornerRadius = 4.0
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 0.6, delay: 0,
                       options: [.curveEaseIn, .curveEaseOut],
                       animations: {
                        self.navigationLogo.center.x += 60
                        self.navigationLogo.center.y -= 30
        },
                       completion: { finished in
                        self.navigationLogo.center.x -= 60
                        self.navigationLogo.center.y += 30
        })
    }
}
