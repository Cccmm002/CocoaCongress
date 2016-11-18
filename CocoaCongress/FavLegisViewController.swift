//
//  FavLegisViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class FavLegisViewController: UIViewController {
    
    var filteredData : [LegisTableData] = []
    
    var tabController : FavTabBarController? = nil
    var searchButton : UIBarButtonItem? = nil
    
    var searchController : UISearchController = UISearchController()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.registerCellNib(LegisTableViewCell.self)
        
        self.searchButton = UIBarButtonItem(image: UIImage(named: "Search-25")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleSearch))
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.delegate = self
        
        self.filteredData = Constants.data.legisFavData
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
        self.filteredData = Constants.data.legisFavData
        self.table.reloadData()
    }
    
}

extension FavLegisViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" || searchText == " " {
            self.resetData()
            return
        }
        self.filteredData = Constants.data.legisFavData.filter { $0.first_name.lowercased().contains(searchText) || $0.last_name.lowercased().contains(searchText) }
        self.table.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.resetData()
        tabController!.navigationItem.titleView = nil
    }
    
}

extension FavLegisViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailViewController") as! LegisDetailViewController
        subContentsVC.legis = self.filteredData[indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension FavLegisViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier, for: indexPath) as! LegisTableViewCell
        let data = self.filteredData[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            let cur = self.filteredData[indexPath.row]
            self.filteredData.remove(at: indexPath.row)
            let count = Constants.data.legisFavData.count
            for i in 0 ..< count {
                if Constants.data.legisFavData[i].id == cur.id {
                    Constants.data.legisFavData.remove(at: i)
                    break
                }
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

}
