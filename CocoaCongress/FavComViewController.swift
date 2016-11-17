//
//  FavComViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class FavComViewController: UIViewController {
    
    var filteredData : [ComTableData] = []
    
    var tabController : FavTabBarController? = nil
    var searchButton : UIBarButtonItem? = nil
    
    var searchController : UISearchController = UISearchController()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.registerCellNib(ComTableViewCell.self)
        
        self.searchButton = UIBarButtonItem(image: UIImage(named: "Search-25")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleSearch))
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.delegate = self
        
        self.filteredData = Constants.data.comFavData
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
        self.filteredData = Constants.data.comFavData
        self.table.reloadData()
    }
    
}

extension FavComViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" || searchText == " " {
            self.resetData()
            return
        }
        self.filteredData = Constants.data.comFavData.filter { $0.title.lowercased().contains(searchText) }
        self.table.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.resetData()
        tabController!.navigationItem.titleView = nil
    }
    
}

extension FavComViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ComTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ComSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ComDetailViewController") as! ComDetailViewController
        subContentsVC.com = self.filteredData[indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension FavComViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ComTableViewCell.identifier, for: indexPath) as! ComTableViewCell
        let data = self.filteredData[indexPath.row]
        cell.setData(data: data)
        return cell
    }
    
}
