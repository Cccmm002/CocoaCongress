//
//  LegisDetailViewController.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/15/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class LegisDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var detailTable: UITableView!
    
    var legis : LegisTableData? = nil
    
    var tableData : [detailTableData] = []
    
    var inFav : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTable.registerCellNib(DetailTableViewCell.self)
        
        self.navigationItem.title = "Legislator Details"
        
        for item in Constants.data.legisFavData {
            if(item.id == self.legis?.id) {
                self.inFav = true
                break
            }
        }
        let img = UIImage(named: (self.inFav ? "star" : "star_empty"))
        let favButton = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleFavorite))
        self.navigationItem.rightBarButtonItem = favButton

        self.imageViewer.image = legis?.image
        
        loadDetail()
    }
    
    func toggleFavorite() {
        if self.inFav {
            let count = Constants.data.legisFavData.count
            for i in 0 ..< count {
                if Constants.data.legisFavData[i].id == legis?.id {
                    Constants.data.legisFavData.remove(at: i)
                    self.inFav = false
                    self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star_empty")
                    break
                }
            }
        }
        else {
            Constants.data.legisFavData.append(legis!)
            self.inFav = true
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "star")
        }
    }
    
    func loadDetail() {
        SwiftSpinner.show("Fetching data...")
        
        Alamofire.request(Constants.Host, method: .get, parameters: ["database":"legislators", "id":legis!.id]).validate().responseJSON { response in
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
    
    func parseData(json: JSON) {
        self.tableData = []
        self.tableData.append(detailTableData(title:"First Name",content:json["personal"]["first_name"].string!,click:false))
        self.tableData.append(detailTableData(title:"Last Name",content:json["personal"]["last_name"].string!,click:false))
        self.tableData.append(detailTableData(title:"State",content:json["personal"]["state_name"].string!,click:false))
        let chamber = ((json["personal"]["chamber"].string!)=="house" ? "House" : "Senate")
        if chamber == "House" {
            let dis = json["personal"]["district"].int!
            self.tableData.append(detailTableData(title:"District",content:String(dis),click:false))
        }
        let pty = json["personal"]["party"].string!
        self.tableData.append(detailTableData(title:"Party",content:(pty == "R" ? "Republican" : (pty == "D" ? "Democratic" : "Independent")),click:false))
        self.tableData.append(detailTableData(title:"Birth Date",content:AppData.dateTransform(from: json["personal"]["birthday"].string!),click:false))
        self.tableData.append(detailTableData(title:"Gender",content:((json["personal"]["gender"].string!)=="M" ? "Male" : "Female"),click:false))
        self.tableData.append(detailTableData(title:"Chamber",content:chamber,click:false))
        self.tableData.append(detailTableData(title:"Fax No.",content:json["personal"]["fax"].string,click:false))
        var twitter = "http://twitter.com/"
        if let tu = json["personal"]["twitter_id"].string {
            twitter = twitter + tu
        }
        else {
            twitter = ""
        }
        self.tableData.append(detailTableData(title:"Twitter",content:twitter,click:true))
        var facebook = "http://www.facebook.com/"
        if let fu = json["personal"]["facebook_id"].string {
            facebook = facebook + fu
        }
        else {
            facebook = ""
        }
        self.tableData.append(detailTableData(title:"Facebook",content:facebook,click:true))
        var website = ""
        if let wu = json["personal"]["website"].string {
            website = wu
        }
        self.tableData.append(detailTableData(title:"Website",content:website,click:true))
        self.tableData.append(detailTableData(title:"Office No.",content:json["personal"]["office"].string!,click:false))
        self.tableData.append(detailTableData(title:"Term ends on",content:AppData.dateTransform(from: json["personal"]["term_end"].string!),click:false))
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
