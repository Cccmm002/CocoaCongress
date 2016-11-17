//
//  FavBillViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class FavBillViewController: UIViewController {
    
    var filteredData : [BillTableData] = []
    
    var tabController : FavTabBarController? = nil
    var searchButton : UIBarButtonItem? = nil
    
    var searchController : UISearchController = UISearchController()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchButton = UIBarButtonItem(image: UIImage(named: "Search-25")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleSearch))
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.delegate = self
        
        self.filteredData = Constants.data.billFavData
    }
    
    func toggleSearch() {
        tabController!.navigationItem.titleView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabController!.navigationItem.rightBarButtonItem = self.searchButton
        if tabController!.navigationItem.titleView != self.searchController.searchBar {
            self.resetData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetData() {
        self.filteredData = Constants.data.billFavData
        self.table.reloadData()
    }
    
}

extension FavBillViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" || searchText == " " {
            self.resetData()
            return
        }
        self.filteredData = Constants.data.billFavData.filter { ($0.active == false) && $0.title.lowercased().contains(searchText) }
        self.table.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.resetData()
        tabController!.navigationItem.titleView = nil
    }
    
}

extension FavBillViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "BillSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "BillDetailViewController") as! BillDetailViewController
        subContentsVC.bill = self.filteredData[indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension FavBillViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell_bill_fav")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell_bill_fav")
        }
        cell!.textLabel?.text = filteredData[indexPath.row].title
        cell!.textLabel?.numberOfLines = 0
        cell!.textLabel?.lineBreakMode = .byWordWrapping
        return cell!
    }
    
}
