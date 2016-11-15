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
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.registerCellNib(LegisTableViewCell.self)

        loadLegisData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadLegisData() {
        SwiftSpinner.show("Fetching data...")
        
        let url: String = Constants.Host/* + "?database=legislators"*/
        Alamofire.request(url, method: .get, parameters: ["database":"legislators"]).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                self.table.reloadData()
            case .failure(let error):
                print(error)
            }
            SwiftSpinner.hide()
        }
    }

}

extension LegStateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.json == nil {
            return 0
        }
        else {
            return self.json["count"].int!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier, for: indexPath) as! LegisTableViewCell
        
        let name = self.json["results"][indexPath.row]["first_name"].string! + " " + self.json["results"][indexPath.row]["last_name"].string!
        let id = self.json["results"][indexPath.row]["bioguide_id"].string!
        let state = self.json["results"][indexPath.row]["state_name"].string!
        let data = LegisTableData(id:id, name:name, state:state)
        cell.setData(data)
        
        return cell
    }
}
