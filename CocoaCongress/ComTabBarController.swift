//
//  ComTabBarController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class ComTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Committees"
        
        let jointView = self.viewControllers?[2] as! ComJointViewController
        let houseView = self.viewControllers?[0] as! ComHouseViewController
        let senateView = self.viewControllers?[1] as! ComSenateViewController
        jointView.tabController = self
        houseView.tabController = self
        senateView.tabController = self
        jointView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        houseView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        senateView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        let titleFont : UIFont = UIFont.systemFont(ofSize: 20.0)
        let attr = [NSFontAttributeName:titleFont]
        jointView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        jointView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol CommitteeTabs {
    func resetData()
}
