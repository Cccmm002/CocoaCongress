//
//  LeftMenuViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LeftMenu: Int {
    case legis = 0
    case bill
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus=["Legislators", "Bills"]
    var legislatorTabBarController : UIViewController!
    var billTabBarController : UIViewController!
    var imageHeaderView: MenuHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let legislatorTabBarController = storyboard.instantiateViewController(withIdentifier: "LegislatorTabBarController") as! LegislatorTabBarController
        self.legislatorTabBarController = UINavigationController(rootViewController: legislatorTabBarController)
        
        let billTabBarController = storyboard.instantiateViewController(withIdentifier: "BillTabBarController") as! BillTabBarController
        self.billTabBarController = UINavigationController(rootViewController: billTabBarController)
        
        //self.tableView.registerCellClass(BaseTableViewCell.self)
        
        //self.imageHeaderView =
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .legis:
            self.slideMenuController()?.changeMainViewController(self.legislatorTabBarController, close: true)
        case .bill:
            self.slideMenuController()?.changeMainViewController(self.billTabBarController, close: true)
        }
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
