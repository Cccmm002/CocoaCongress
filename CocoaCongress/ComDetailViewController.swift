//
//  ComDetailViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ComDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var com : ComTableData? = nil
    
    var tableData : [detailTableData] = []
    
    var inFav : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailTable.registerCellNib(DetailTableViewCell.self)
        
        self.navigationItem.title = "Committee Details"
        
        for item in Constants.data.comFavData {
            if(item.id == self.com?.id) {
                self.inFav = true
                break
            }
        }
        let img = UIImage(named: (self.inFav ? "star" : "star_empty"))
        let favButton = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleFavorite))
        self.navigationItem.rightBarButtonItem = favButton
        
        self.textView.text = com?.title
        
        self.loadDetail()
    }
    
    func toggleFavorite() {
        if self.inFav {
            let count = Constants.data.comFavData.count
            for i in 0 ..< count {
                if Constants.data.comFavData[i].id == com?.id {
                    Constants.data.comFavData.remove(at: i)
                    self.inFav = false
                    self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star_empty")
                    break
                }
            }
        }
        else {
            Constants.data.comFavData.append(com!)
            self.inFav = true
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData(json: JSON) {
        self.tableData = []
        self.tableData.append(detailTableData(title:"ID",content:json["committee_id"].string,click:false))
        self.tableData.append(detailTableData(title:"Parent ID",content:json["parent_id"].string,click:false))
        let chmb = json["chamber"].string!
        self.tableData.append(detailTableData(title:"Chamber",content:(chmb == "house" ? "House" : (chmb == "senate" ? "Senate" : "Joint")),click:false))
        self.tableData.append(detailTableData(title:"Office",content:json["office"].string,click:false))
        self.tableData.append(detailTableData(title:"Contact",content:json["phone"].string,click:false))
    }
    
    func loadDetail() {
        SwiftSpinner.show("Fetching data...")
        
        Alamofire.request(Constants.Host, method: .get, parameters: ["database":"committees", "id":com!.id]).validate().responseJSON { response in
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        
        cell.setData(data: self.tableData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }

}
