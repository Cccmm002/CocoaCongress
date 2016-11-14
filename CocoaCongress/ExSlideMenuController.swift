//
//  ExSlideMenuController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController: SlideMenuController {

    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is LegislatorTabBarController ||
                vc is BillTabBarController ||
                vc is ComTabBarController ||
                vc is FavTabBarController ||
                vc is AboutViewController{
                return true
            }
        }
        return false
    }

}
