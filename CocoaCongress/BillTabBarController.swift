//
//  BillTabBarController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class BillTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Bills"

        let activeView = self.viewControllers?[0] as! BillActiveViewController
        let newView = self.viewControllers?[1] as! BillNewViewController
        
        activeView.tabController = self
        newView.tabController = self
        activeView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        newView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        let titleFont : UIFont = UIFont.systemFont(ofSize: 20.0)
        let attr = [NSFontAttributeName:titleFont]
        activeView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        activeView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        newView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        newView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
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

protocol BillTabs {
    func resetData()
}
