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

class AppData {
    var legisData : [LegisTableData] = []
    var state_list : [String] = []
    
    func existLegisData() -> Bool {
        if legisData.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func buildLegisData(json : JSON) {
        self.legisData = []
        let count = json["count"].int!
        for i in 0 ..< count {
            let state = json["results"][i]["state_name"].string!
            let fname = json["results"][i]["first_name"].string!
            let lname = json["results"][i]["last_name"].string!
            let id = json["results"][i]["bioguide_id"].string!
            let chamber = json["results"][i]["chamber"].string!
            let data = LegisTableData(id:id, fname:fname, lname:lname, state:state, chamber:chamber)
            self.legisData.append(data)
        }
    }
    
    func loadLegisData(view : LegislatorTabs) {
        if !(existLegisData()) {
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
                    let json = JSON(value)
                    self.buildLegisData(json: json)
                    view.resetData()
                case .failure(let error):
                    print(error)
                }
                SwiftSpinner.hide()
            }
        }
        
    }
}
