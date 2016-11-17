//
//  AppData.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/15/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner

class BillTableData: NSObject, NSCoding {
    var id : String
    var title : String
    var active : Bool
    
    init(id: String, title: String, active: Bool) {
        self.title = title
        self.id = id
        self.active = active
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.active = true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        //aCoder.encode(boolv: self.active, forKey: "active")
    }
}

class AppData {
    var state_list : [String] = []
    
    var legisData : [LegisTableData] = []
    var billData : [BillTableData] = []
    var comData : [ComTableData] = []
    
    var legisFavData : [LegisTableData] = []
    var billFavData : [BillTableData] = []
    var comFavData : [ComTableData] = []
    
    let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init() {
        self._getFav()
    }
    
    func existLegisData() -> Bool {
        if self.legisData.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func existBillData() -> Bool {
        if self.billData.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func existComData() -> Bool {
        if self.comData.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func _getFav() {
        let legis : [LegisTableData]? = NSKeyedUnarchiver.unarchiveObject(withFile: self.DocumentsDirectory.appendingPathComponent("legis").path) as? [LegisTableData]
        if let l = legis {
            self.legisFavData = l
        }
        else {
            self.legisFavData = []
        }
        let bills : [BillTableData]? = NSKeyedUnarchiver.unarchiveObject(withFile: self.DocumentsDirectory.appendingPathComponent("bills").path) as? [BillTableData]
        if let b = bills {
            self.billFavData = b
        }
        else {
            self.billFavData = []
        }
        let coms : [ComTableData]? = NSKeyedUnarchiver.unarchiveObject(withFile: self.DocumentsDirectory.appendingPathComponent("coms").path) as? [ComTableData]
        if let c = coms {
            self.comFavData = c
        }
        else {
            self.comFavData = []
        }
    }
    
    func _buildLegisData(json : JSON) {
        self.legisData = []
        let count = json["count"].int!
        for i in 0 ..< count {
            let state = json["results"][i]["state_name"].string!
            let fname = json["results"][i]["first_name"].string!
            let lname = json["results"][i]["last_name"].string!
            let id = json["results"][i]["bioguide_id"].string!
            let chamber = json["results"][i]["chamber"].string!
            let party = json["results"][i]["party"].string!
            let data = LegisTableData(id:id, fname:fname, lname:lname, state:state, chamber:chamber, party:party)
            self.legisData.append(data)
        }
    }
    
    func _buildBillData(json : JSON) {
        self.billData = []
        let count = json["count"].int!
        for i in 0 ..< count {
            let id = json["results"][i]["bill_id"].string!
            let title = json["results"][i]["official_title"].string!
            let active = json["results"][i]["active"].bool!
            let data = BillTableData(id: id, title: title, active: active)
            self.billData.append(data)
        }
    }
    
    func _buildComData(json : JSON) {
        self.comData = []
        if let items = json.array {
            for item in items {
                let title = item["name"].string!
                let id = item["committee_id"].string!
                let chamber = item["chamber"].string!
                let data = ComTableData(id: id, title: title, chamber: chamber)
                self.comData.append(data)
            }
        }
    }
    
    func loadLegisData(view : LegislatorTabs) {
        if !(existLegisData()) {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request(Constants.Host, method: .get, parameters: ["database":"states"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jstates = JSON(value)
                    self.state_list = jstates.arrayValue.map { $0.string! }
                    self.state_list.insert("All States", at: 0)
                case .failure(let error):
                    print(error)
                }
            }
            
            Alamofire.request(Constants.Host, method: .get, parameters: ["database":"legislators"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self._buildLegisData(json: json)
                    view.resetData()
                case .failure(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    func loadBillData(view : BillTabs) {
        if !(existBillData()) {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request(Constants.Host, method: .get, parameters: ["database":"bills"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self._buildBillData(json: json)
                    view.resetData()
                case .failure(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    func loadComData(view : CommitteeTabs) {
        if !(existComData()) {
            SwiftSpinner.show("Fetching data...")
            
            Alamofire.request(Constants.Host, method: .get, parameters: ["database":"committees"]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self._buildComData(json: json)
                    view.resetData()
                case .failure(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
    }
    
    static func dateTransform(from: String?) -> String {
        if let f = from {
            let tf = f.substring(to: f.index(f.startIndex, offsetBy: 10))
        
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateSource = DateFormatter()
            dateSource.locale = Locale.current
            dateSource.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: dateSource.date(from: tf)!)
        }
        else {
            return ""
        }
    }
}
