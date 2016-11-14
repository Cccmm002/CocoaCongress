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
    case com
    case fav
    case about
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus=["Legislators", "Bills", "Committees", "Favorites", "About"]
    var legislatorTabBarController : UIViewController!
    var billTabBarController : UIViewController!
    var comTabBarController : UIViewController!
    var favTabBarController : UIViewController!
    var aboutViewController : UIViewController!
    var imageHeaderView: MenuHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let legislatorTabBarController = storyboard.instantiateViewController(withIdentifier: "LegislatorTabBarController") as! LegislatorTabBarController
        self.legislatorTabBarController = UINavigationController(rootViewController: legislatorTabBarController)
        
        let billTabBarController = storyboard.instantiateViewController(withIdentifier: "BillTabBarController") as! BillTabBarController
        self.billTabBarController = UINavigationController(rootViewController: billTabBarController)
        
        let comTabBarController = storyboard.instantiateViewController(withIdentifier: "ComTabBarController") as! ComTabBarController
        self.comTabBarController = UINavigationController(rootViewController: comTabBarController)
        
        let favTabBarController = storyboard.instantiateViewController(withIdentifier: "FavTabBarController") as! FavTabBarController
        self.favTabBarController = UINavigationController(rootViewController: favTabBarController)
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        self.imageHeaderView = MenuHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .legis:
            self.slideMenuController()?.changeMainViewController(self.legislatorTabBarController, close: true)
        case .bill:
            self.slideMenuController()?.changeMainViewController(self.billTabBarController, close: true)
        case .com:
            self.slideMenuController()?.changeMainViewController(self.comTabBarController, close: true)
        case .fav:
            self.slideMenuController()?.changeMainViewController(self.favTabBarController, close: true)
        case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
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

extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legis, .bill, .com, .fav, .about:
                //return BaseTableViewCell.height()
                return 48
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .legis, .bill, .com, .fav, .about:
                let cell = UITableViewCell()
                cell.textLabel?.text = menus[indexPath.row]
                cell.backgroundColor = UIColor(red: 226.0, green: 235.0, blue: 221.0, alpha: 1.0)
                cell.textLabel?.textColor = UIColor(hex: "9E9E9E")
                return cell
            }
        }
        return UITableViewCell()
    }
}
