//
//  LegisTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/14/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

struct LegisTableData {
    
    var id: String
    var name: String
    var state: String
    
    init(id: String, name: String, state: String) {
        self.id=id
        self.name=name
        self.state=state
    }
    
}

class LegisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var dataState: UILabel!
    
    class var identifier: String { return String.className(self) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: Any?) {
        if let data = data as? LegisTableData {
            self.dataName.text = data.name
            self.dataState.text = data.state
            
        }
    }
    
}
