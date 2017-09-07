//
//  AutoNetworkCheck.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 6/22/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class AutoNetworkCheckViewController: UIViewController {
    
    var pullRefresher: UIRefreshControl!
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePullRefresher()
        self.configureLoadingIndicator()
    }
    
    private func configurePullRefresher(){
        pullRefresher = UIRefreshControl()
        let attribute = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
    }
    
    private func configureLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    func loadData() {
        
    }
    
    func refreshData() {
        if reachability.isReachable {
            self.loadData()
        } else {
            self.showAlert()
            pullRefresher.endRefreshing()
            loadingIndicator.stopAnimation()
        }
    }
    
    private func showAlert() {
        popUpView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 80, y: self.view.frame.height / 2, width: 160, height: 80))
        popUpView.backgroundColor = UIColor.noNetworkAlertGray()
        popUpView.layer.cornerRadius = 8.0
        let alertLabel = UILabel(frame: CGRect(x: 0, y: 0, width: popUpView.frame.width, height: popUpView.frame.height))
        alertLabel.text = "!\n没有网络连接"
        alertLabel.font = UIFont(name: "Arial", size: 18)
        alertLabel.textColor = UIColor.black
        alertLabel.numberOfLines = 2
        alertLabel.textAlignment = .center
        popUpView.addSubview(alertLabel)
        
        self.view.addSubview(popUpView)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.removeAlert), userInfo: nil, repeats: false)
    }
    
    func removeAlert(){
        if popUpView != nil { // Dismiss the view from here
            popUpView.removeFromSuperview()
        }
    }
}

class AutoNetworkCheckTableViewController: UITableViewController {
    
    var pullRefresher: UIRefreshControl!
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePullRefresher()
        self.configureLoadingIndicator()
    }
    
    private func configurePullRefresher(){
        pullRefresher = UIRefreshControl()
        let attribute = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
    }
    
    private func configureLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    func loadData() {
        
    }
    
    func refreshData() {
        if reachability.isReachable {
            self.loadData()
        } else {
            self.showAlert()
            pullRefresher.endRefreshing()
            loadingIndicator.stopAnimation()
        }
    }
    
    private func showAlert() {
        popUpView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 80, y: self.view.frame.height / 2, width: 160, height: 80))
        popUpView.backgroundColor = UIColor.noNetworkAlertGray()
        popUpView.layer.cornerRadius = 8.0
        let alertLabel = UILabel(frame: CGRect(x: 0, y: 0, width: popUpView.frame.width, height: popUpView.frame.height))
        alertLabel.text = "!\n没有网络连接"
        alertLabel.font = UIFont(name: "Arial", size: 18)
        alertLabel.textColor = UIColor.black
        alertLabel.numberOfLines = 2
        alertLabel.textAlignment = .center
        popUpView.addSubview(alertLabel)
        
        self.view.addSubview(popUpView)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.removeAlert), userInfo: nil, repeats: false)
    }
    
    func removeAlert(){
        if popUpView != nil { // Dismiss the view from here
            popUpView.removeFromSuperview()
        }
    }
}
