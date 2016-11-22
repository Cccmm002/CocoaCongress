//
//  BillTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/22/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class BillTableData: NSObject, NSCoding {
    var id : String
    var title : String
    var active : Bool
    var introduced : String
    
    init(id: String, title: String, active: Bool, introduced: String) {
        self.title = title
        self.id = id
        self.active = active
        self.introduced = introduced
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.introduced = aDecoder.decodeObject(forKey: "introduced") as! String
        self.active = true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.introduced, forKey: "introduced")
        //aCoder.encode(boolv: self.active, forKey: "active")
    }
}

class BillTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    class var identifier: String { return String.className(self) }
    
    open class func height() -> CGFloat {
        return 120
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: BillTableData) {
        labelTitle.text = data.title
        labelTitle.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelID.text = data.id
        labelDate.text = AppData.dateTransform(from: data.introduced)
    }
    
}
