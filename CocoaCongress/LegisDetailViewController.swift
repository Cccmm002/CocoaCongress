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

class LegisDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var detailTable: UITableView!
    
    var legis : LegisTableData? = nil
    
    var tableData : [detailTableData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTable.registerCellNib(LegisDetailTableViewCell.self)
        
        self.navigationItem.title = "Legislator Details"

        self.imageViewer.image = legis?.image
        
        loadDetail()
    }
    
    func loadDetail() {
        Alamofire.request(Constants.Host, method: .get, parameters: ["database":"legislators", "id":legis!.id]).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseData(json:json)
                self.detailTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseData(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateSource = DateFormatter()
        dateSource.locale = Locale.current
        dateSource.dateFormat = "yyyy-MM-dd"
        
        self.tableData = []
        self.tableData.append(detailTableData(title:"First Name",content:json["personal"]["first_name"].string!,click:false))
        self.tableData.append(detailTableData(title:"Last Name",content:json["personal"]["last_name"].string!,click:false))
        self.tableData.append(detailTableData(title:"State",content:json["personal"]["state_name"].string!,click:false))
        let date_birth = dateFormatter.string(from: dateSource.date(from: json["personal"]["birthday"].string!)!)
        self.tableData.append(detailTableData(title:"Birth Date",content:date_birth,click:false))
        self.tableData.append(detailTableData(title:"Gender",content:((json["personal"]["gender"].string!)=="M" ? "Male" : "Female"),click:false))
        self.tableData.append(detailTableData(title:"Chamber",content:((json["personal"]["chamber"].string!)=="house" ? "House" : "Senate"),click:false))
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
        let date_ends = dateFormatter.string(from: dateSource.date(from: json["personal"]["term_end"].string!)!)
        self.tableData.append(detailTableData(title:"Term ends on",content:date_ends,click:false))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LegisDetailTableViewCell.identifier, for: indexPath) as! LegisDetailTableViewCell
        cell.labelTitle.text = self.tableData[indexPath.row].title
        if self.tableData[indexPath.row].content == "" {
            cell.labelContent.text = "N.A."
        }
        else {
            if self.tableData[indexPath.row].clickable {
                cell.labelContent.text = self.tableData[indexPath.row].title + " Link"
                cell.labelContent.textColor = UIColor.blue
                cell.createLink(url: self.tableData[indexPath.row].content)
            }
            else {
                cell.labelContent.text = self.tableData[indexPath.row].content
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
}
