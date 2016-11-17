//
//  LegStateViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class LegStateViewController: UIViewController, LegislatorTabs {
    
    var filteredData : [LegisTableData] = []
    var dic : [String:[LegisTableData]] = [:]
    var dic_keys : [String] = []
    var current_state : Int = 0
    
    var tabController : LegislatorTabBarController? = nil
    var rightButton: UIBarButtonItem? = nil
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.registerCellNib(LegisTableViewCell.self)
        
        self.rightButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onFilterClick))

        if !Constants.data.existLegisData() {
            Constants.data.loadLegisData(view: self)
        }
        else {
            resetData()
        }
    }
    
    func onFilterClick() {
        let storyboard = UIStoryboard(name: "LegisSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "StatePickerViewController") as! StatePickerViewController
        subContentsVC.states = Constants.data.state_list
        subContentsVC.stateView = self
        subContentsVC.current_state = self.current_state
        self.navigationController?.pushViewController(subContentsVC, animated: false)
    }
    
    func resetData() {
        self.filteredData = Constants.data.legisData
        buildDic()
        self.current_state = 0
        self.table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabController!.navigationItem.title = "Legislators"
        tabController!.navigationItem.rightBarButtonItem = self.rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildDic() {
        self.dic = [:]
        let count = self.filteredData.count
        for i in 0 ..< count {
            let data = self.filteredData[i]
            let state = data.state
            let c = String(state[state.startIndex])
            if self.dic[c] == nil {
                self.dic[c] = [];
            }
            self.dic[c]?.append(data)
        }
        self.dic_keys = Array(self.dic.keys)
        self.dic_keys.sort()
        let kc = self.dic.count
        for i in 0 ..< kc {
            self.dic[self.dic_keys[i]]?.sort(by: legisSort)
        }
    }
    
    func legisSort(this: LegisTableData, that: LegisTableData) -> Bool {
        if this.state < that.state {
            return true
        }
        else if this.state == that.state {
            return this.last_name < that.last_name
        }
        else {
            return false
        }
    }

}

extension LegStateViewController : UITableViewDelegate {
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

extension LegStateViewController: UITableViewDataSource {
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
