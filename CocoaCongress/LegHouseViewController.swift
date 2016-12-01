//
//  LegHouseViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/15/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class LegHouseViewController: UIViewController, LegislatorTabs {
    
    var filteredData : [LegisTableData] = []
    var dic : [String:[LegisTableData]] = [:]
    var dic_keys : [String] = []
    
    var tabController : LegislatorTabBarController? = nil
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
        
        if !Constants.data.existLegisData() {
            Constants.data.loadLegisData(view: self)
        }
        else {
            resetData()
        }
    }
    
    func toggleSearch() {
        tabController!.navigationItem.titleView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabController!.navigationItem.title = "Legislators"
        tabController!.navigationItem.rightBarButtonItem = self.searchButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildDic() {
        self.dic = [:]
        let count = self.filteredData.count
        for i in 0 ..< count {
            let lname = self.filteredData[i].last_name
            let c = String(lname[lname.startIndex])
            if self.dic[c] == nil {
                self.dic[c] = [];
            }
            self.dic[c]!.append(self.filteredData[i])
        }
        self.dic_keys = Array(self.dic.keys)
        self.dic_keys.sort()
        let ck = self.dic_keys.count
        for i in 0 ..< ck {
            dic[dic_keys[i]]?.sort { $0.last_name < $1.last_name }
        }
    }
    
    func resetData() {
        self.filteredData = Constants.data.legisData.filter{ $0.chamber == "house" }
        buildDic()
        self.table.reloadData()
    }
    
}

extension LegHouseViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        if searchText == "" || searchText == " " {
            self.resetData()
            return
        }
        self.filteredData = Constants.data.legisData.filter { ($0.chamber == "house") && ($0.first_name.lowercased().contains(searchText) || $0.last_name.lowercased().contains(searchText)) }
        self.buildDic()
        self.table.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.resetData()
        tabController!.navigationItem.titleView = nil
    }

}

extension LegHouseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailViewController") as! LegisDetailViewController
        subContentsVC.legis = self.dic[self.dic_keys[indexPath.section]]?[indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegHouseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !Constants.data.existLegisData() {
            return 0
        }
        else {
            let v : Int = (self.dic[self.dic_keys[section]]?.count)!
            return v
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier, for: indexPath) as! LegisTableViewCell
        let data = self.dic[self.dic_keys[indexPath.section]]?[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !Constants.data.existLegisData() {
            return 0
        }
        else {
            return self.dic_keys.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !Constants.data.existLegisData() {
            return []
        }
        else {
            return self.dic_keys
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !Constants.data.existLegisData() {
            return ""
        }
        else {
            return self.dic_keys[section]
        }
    }
}
