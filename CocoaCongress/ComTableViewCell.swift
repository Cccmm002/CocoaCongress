//
//  ComTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/16/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class ComTableData: NSObject, NSCoding {
    var id : String
    var title : String
    var chamber : String
    
    init(id: String, title: String, chamber: String) {
        self.id = id
        self.title = title
        self.chamber = chamber
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.chamber = aDecoder.decodeObject(forKey: "chamber") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.chamber, forKey: "chamber")
    }
}

class ComTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    class var identifier: String { return String.className(self) }
    
    open class func height() -> CGFloat {
        return 44
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ComTableData) {
        self.labelID.text = data.id
        self.labelTitle.text = data.title
    }
    
}
