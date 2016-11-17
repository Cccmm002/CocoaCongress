//
//  AppDelegate.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

struct Constants {
    static let Host : String = "http://lowcost-env.mmist7h7sn.us-west-1.elasticbeanstalk.com/Congress/CongressWeb/congressRequest.php"
    static let LegImgServer : String = "https://theunitedstates.io/images/congress/original/"
    static let data : AppData = AppData()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate func createMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let legislatorTabBarController = storyboard.instantiateViewController(withIdentifier: "LegislatorTabBarController") as! LegislatorTabBarController
        let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController

        let nvc: UINavigationController = UINavigationController(rootViewController: legislatorTabBarController)
        
        //UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        
        leftMenuViewController.legislatorTabBarController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.rootViewController = slideMenuController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.makeKeyAndVisible()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.createMenuView()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if !NSKeyedArchiver.archiveRootObject(Constants.data.legisFavData, toFile: Constants.data.DocumentsDirectory.appendingPathComponent("legis").path) {
            print("Save legislators failed.")
        }
        if !NSKeyedArchiver.archiveRootObject(Constants.data.billFavData, toFile: Constants.data.DocumentsDirectory.appendingPathComponent("bills").path) {
            print("Save bills failed.")
        }
        if !NSKeyedArchiver.archiveRootObject(Constants.data.comFavData, toFile: Constants.data.DocumentsDirectory.appendingPathComponent("coms").path) {
            print("Save committees failed.")
        }
    }


}

