//
//  LegStateViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/13/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class LegStateViewController: UIViewController {
    
    var json : JSON = nil
    var dataSet : [LegisTableData] = []
    var filteredData : [LegisTableData] = []
    var dic : [String:[LegisTableData]] = [:]
    var dic_keys : [String] = []
    var state_list: [String] = []
    var current_state : Int = 0
    
    var tabController : LegislatorTabBarController? = nil
    var rightButton: UIBarButtonItem? = nil
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.registerCellNib(LegisTableViewCell.self)
        
        self.rightButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onFilterClick))

        loadLegisData()
    }
    
    func onFilterClick() {
        let storyboard = UIStoryboard(name: "LegisSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "StatePickerViewController") as! StatePickerViewController
        subContentsVC.states = self.state_list
        subContentsVC.stateView = self
        subContentsVC.current_state = self.current_state
        self.navigationController?.pushViewController(subContentsVC, animated: false)
    }
    
    func clearFilterContent() {
        self.filteredData = self.dataSet
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

    func loadLegisData() {
        if json == nil {
            SwiftSpinner.show("Fetching data...")
        
            let url: String = Constants.Host
            
            Alamofire.request(url, method: .get, parameters: ["database":"states"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jstates = JSON(value)
                    self.state_list = jstates.arrayValue.map { $0.string! }
                    self.state_list.insert("All States", at: 0)
                case .failure(let error):
                    print(error)
                }
            }
            
            Alamofire.request(url, method: .get, parameters: ["database":"legislators"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.json = JSON(value)
                    self.buildData()
                    self.filteredData = self.dataSet
                    self.buildDic()
                    self.table.reloadData()
                case .failure(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
        else {
            self.table.reloadData()
        }
    }
    
    func buildData() {
        self.dataSet = []
        let count = self.json["count"].int!
        for i in 0 ..< count {
            let state = self.json["results"][i]["state_name"].string!
            let fname = self.json["results"][i]["first_name"].string!
            let lname = self.json["results"][i]["last_name"].string!
            let id = self.json["results"][i]["bioguide_id"].string!
            let data = LegisTableData(id:id, fname:fname, lname:lname, state:state)
            self.dataSet.append(data)
        }
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
    }

}

extension LegStateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisSubViews", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailViewController") as! LegisDetailViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegStateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.json == nil {
            return 0
        }
        else {
            let v : Int = (self.dic[self.dic_keys[section]]?.count)!
            return v
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell: section: " + String(indexPath.section) + " row: " + String(indexPath.row))
        let cell = tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier, for: indexPath) as! LegisTableViewCell
        let data = self.dic[self.dic_keys[indexPath.section]]?[indexPath.row]
        cell.setData(data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.json == nil {
            return 0
        }
        else {
            return self.dic_keys.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.json == nil {
            return []
        }
        else {
            return self.dic_keys
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.json == nil {
            return ""
        }
        else {
            return self.dic_keys[section]
        }
    }
}
