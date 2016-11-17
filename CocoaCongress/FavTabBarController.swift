//
//  FavTabBarController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class FavTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Favorites"
        
        let legisView = self.viewControllers?[0] as! FavLegisViewController
        let billView = self.viewControllers?[1] as! FavBillViewController
        let comView = self.viewControllers?[2] as! FavComViewController
        
        legisView.tabController = self
        billView.tabController = self
        comView.tabController = self
        
        legisView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        billView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        comView.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        let titleFont : UIFont = UIFont.systemFont(ofSize: 20.0)
        let attr = [NSFontAttributeName:titleFont]
        legisView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        legisView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        billView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        billView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        comView.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        comView.tabBarItem.setTitleTextAttributes(attr, for: .selected)
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
