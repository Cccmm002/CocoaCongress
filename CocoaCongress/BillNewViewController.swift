//
//  BillNewViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class BillNewViewController: UIViewController, BillTabs {
    
    var filteredData : [BillTableData] = []
    
    var tabController : BillTabBarController? = nil
    
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
        
        if !Constants.data.existBillData() {
            Constants.data.loadBillData(view: self)
        }
        else {
            resetData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabController!.navigationItem.title = "Bills"
        tabController!.navigationItem.rightBarButtonItem = self.searchButton
    }
    
    func toggleSearch() {
        tabController!.navigationItem.titleView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetData() {
        self.filteredData = Constants.data.billData.filter { $0.active == false }
        self.table.reloadData()
    }
    
}

extension BillNewViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" || searchText == " " {
            self.resetData()
            return
        }
        self.filteredData = Constants.data.billData.filter { ($0.active == false) && $0.title.lowercased().contains(searchText) }
        self.table.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.resetData()
        tabController!.navigationItem.titleView = nil
    }
}

extension BillNewViewController : UITableViewDelegate {
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

extension BillNewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !Constants.data.existBillData() {
            return 0
        }
        else {
            return self.filteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell_bill_new")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell_bill_new")
        }
        cell!.textLabel?.text = filteredData[indexPath.row].title
        cell!.textLabel?.numberOfLines = 0
        cell!.textLabel?.lineBreakMode = .byWordWrapping
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
