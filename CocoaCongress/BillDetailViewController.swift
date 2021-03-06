//
//  BillDetailViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class BillDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var bill : BillTableData? = nil
    
    var tableData : [detailTableData] = []
    
    var inFav : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTable.registerCellNib(DetailTableViewCell.self)
        
        self.navigationItem.title = "Bill Details"
        
        for item in Constants.data.billFavData {
            if(item.id == self.bill?.id) {
                self.inFav = true
                break
            }
        }
        let img = UIImage(named: (self.inFav ? "star" : "star_empty"))
        let favButton = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleFavorite))
        self.navigationItem.rightBarButtonItem = favButton
        
        self.textView.text = bill?.title

        self.loadDetail()
    }
    
    func toggleFavorite() {
        if self.inFav {
            let count = Constants.data.billFavData.count
            for i in 0 ..< count {
                if Constants.data.billFavData[i].id == bill?.id {
                    Constants.data.billFavData.remove(at: i)
                    self.inFav = false
                    self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star_empty")
                    break
                }
            }
        }
        else {
            Constants.data.billFavData.append(bill!)
            self.inFav = true
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star")
        }
    }
    
    func parseData(json: JSON) {
        self.tableData = []
        self.tableData.append(detailTableData(title:"Bill ID",content:json["bill_id"].string!,click:false))
        self.tableData.append(detailTableData(title:"Bill Type",content:json["bill_type"].string!.uppercased(),click:false))
        let sponsor = json["sponsor"]["title"].string! + " " + json["sponsor"]["first_name"].string! + " " + json["sponsor"]["last_name"].string!
        self.tableData.append(detailTableData(title:"Sponsor",content:sponsor,click:false))
        self.tableData.append(detailTableData(title:"Last Action",content:AppData.dateTransform(from: json["last_action_at"].string),click:false))
        self.tableData.append(detailTableData(title:"PDF",content:json["last_version","urls","pdf"].string,click:true))
        self.tableData.append(detailTableData(title:"Chamber",content:((json["chamber"].string!)=="house" ? "House" : "Senate"),click:false))
        self.tableData.append(detailTableData(title:"Last Vote",content:AppData.dateTransform(from: json["last_vote_at"].string),click:false))
        self.tableData.append(detailTableData(title:"Status",content:(json["history"]["active"].bool!) ? "Active" : "New",click:false))
    }
    
    func loadDetail() {
        SwiftSpinner.show("Fetching data...")
        
        Alamofire.request(Constants.Host, method: .get, parameters: ["database":"bills", "id":bill!.id]).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseData(json:json)
                self.detailTable.reloadData()
            case .failure(let error):
                print(error)
            }
            SwiftSpinner.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        
        cell.setData(data: self.tableData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
}
