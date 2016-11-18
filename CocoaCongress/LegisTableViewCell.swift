//
//  LegisTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/14/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class LegisTableData: NSObject, NSCoding {
    
    var id: String
    var chamber: String
    var first_name: String
    var last_name: String
    var state: String
    var party: String
    var district: String
    var image: UIImage?
    
    init(id: String, fname: String, lname: String, state: String, chamber: String, party: String, district: String) {
        self.id=id
        self.first_name=fname
        self.last_name=lname
        self.state=state
        self.image=nil
        self.chamber=chamber
        self.party=party
        self.district=district
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.chamber = aDecoder.decodeObject(forKey: "chamber") as! String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as! String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as! String
        self.state = aDecoder.decodeObject(forKey: "state") as! String
        self.party = aDecoder.decodeObject(forKey: "party") as! String
        self.district = aDecoder.decodeObject(forKey: "district") as! String
        self.image = nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.chamber, forKey: "chamber")
        aCoder.encode(self.first_name, forKey: "first_name")
        aCoder.encode(self.last_name, forKey: "last_name")
        aCoder.encode(self.state, forKey: "state")
        aCoder.encode(self.party, forKey: "party")
        aCoder.encode(self.district, forKey: "district")
    }

}

class LegisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var dataState: UILabel!
    
    var legis : LegisTableData? = nil
    
    class var identifier: String { return String.className(self) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open class func height() -> CGFloat {
        return 50
    }
    
    func setData(_ data: Any?) {
        if let data = data as? LegisTableData {
            self.legis = data
            
            self.dataName.text = data.first_name + " " + data.last_name
            var dataState = data.state
            if data.chamber == "house" {
                dataState += " - " + data.district
            }
            self.dataState.text = dataState + "  (" + data.party + ")"
            
            if data.image == nil {
                self.downloadImage(id: data.id)
            }
            else {
                self.dataImage.image = data.image
            }
        }
    }
    
    func getDataFromUrl(url: URL, id: String, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?, _ id: String) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error, id)
            }.resume()
    }
    
    func downloadImage(id: String) {
        let imgUrl : String = Constants.LegImgServer + id + ".jpg"
        if let checkedUrl = URL(string: imgUrl) {
            getDataFromUrl(url: checkedUrl, id: id) { (data, response, error, id)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { () -> Void in
                    if id == self.legis!.id {
                        self.dataImage.frame = CGRect(x:0, y:0, width:42, height:50)
                        self.dataImage.contentMode = .scaleToFill
                        self.legis!.image = UIImage(data: data)
                        self.dataImage.image = self.legis!.image
                    }
                }
            }
        }
        
    }
    
}
