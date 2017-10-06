//
//  LoadingViewUtil.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 9/8/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class LoadingViewUtil {
    class func buildLoadingView(frame: CGRect, text: String) -> UIView {
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor.white
        loadingView.layer.cornerRadius = 8.0
        loadingView.layer.borderWidth = 1.0
        loadingView.layer.borderColor = UIColor.themeOrange().cgColor
        
        let loadingLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 80, height: 40))
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loadingView.addSubview(loadingIndicator)
        loadingView.addSubview(loadingLabel)
        
        loadingIndicator.activityIndicatorViewStyle = .white
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.startAnimating()
        loadingLabel.text = text
        loadingLabel.font = UIFont(name: "Arial", size: 16)
        loadingLabel.textColor = UIColor.themeOrange()
        loadingLabel.textAlignment = .center
        
        return loadingView
    }
}
