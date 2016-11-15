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
        stateView.tabController = self
        houseView.tabController = self
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
