//
//  LegislatorTabBarController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class LegislatorTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Legislators"
        
        let stateView = self.viewControllers?[0] as! LegStateViewController
        let houseView = self.viewControllers?[1] as! LegHouseViewController
        let senateView = self.viewControllers?[2] as! LegSenateViewController
        stateView.tabController = self
        houseView.tabController = self
        senateView.tabController = self
        stateView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        houseView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        senateView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        let titleFont : UIFont = UIFont.systemFont(ofSize: 20.0)
        let attr = [NSFontAttributeName:titleFont]
        stateView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        stateView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        houseView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        houseView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        senateView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        senateView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

}

protocol LegislatorTabs {
    func resetData()
}
