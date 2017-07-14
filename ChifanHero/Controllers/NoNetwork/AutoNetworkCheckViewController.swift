//
//  AutoNetworkCheckViewController.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 6/22/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class AutoNetworkCheckViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .red
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        if !(Network.reachability?.isReachable)! {
            let lml_place = NoNetworkView.init(frame: self.view.bounds)
            
            let imgs = [
                "ChifanHero_NoNetwork"
            ]
            
            
            lml_place.showNonetView("没有连接到网络...", imageArray: imgs, toView: self.view)
            lml_place.click_closure = {
                
                if (Network.reachability?.isReachable)! {
                    lml_place.hide()
                }
            }
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    
}
