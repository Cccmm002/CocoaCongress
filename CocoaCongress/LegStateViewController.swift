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
    var dic : [String:[LegisTableData]] = [:]
    var dic_keys : [String] = []
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        
        self.table.registerCellNib(LegisTableViewCell.self)

        loadLegisData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadLegisData() {
        if json == nil {
            SwiftSpinner.show("Fetching data...")
        
            let url: String = Constants.Host/* + "?database=legislators"*/
            Alamofire.request(url, method: .get, parameters: ["database":"legislators"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.json = JSON(value)
                    print("Information of legislators fetched successfully!")
                    self.buildDic()
                    self.table.reloadData()
                case .failure(let error):
                    print("Information of legislators failed!!!")
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
        else {
            self.table.reloadData()
        }
    }
    
    func buildDic() {
        self.dic = [:]
        let count = self.json["count"].int!
        for i in 0 ..< count {
            let state = self.json["results"][i]["state_name"].string!
            let fname = self.json["results"][i]["first_name"].string!
            let lname = self.json["results"][i]["last_name"].string!
            let id = self.json["results"][i]["bioguide_id"].string!
            let data = LegisTableData(id:id, fname:fname, lname:lname, state:state)
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
        
    }
}

extension LegStateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.json == nil {
            print("Section number " + String(section) + ": 0")
            return 0
        }
        else {
            let v : Int = (self.dic[self.dic_keys[section]]?.count)!
            print("Section number " + String(section) + ": " + String(v))
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
            print("Current section number: 0")
            return 0
        }
        else {
            print("Current section number: " + String(self.dic_keys.count))
            return self.dic_keys.count
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.json == nil {
            return []
        }
        else {
            print("Get all section titles")
            return self.dic_keys
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.json == nil {
            return ""
        }
        else {
            print("Get section title: " + self.dic_keys[section])
            return self.dic_keys[section]
        }
    }
}
