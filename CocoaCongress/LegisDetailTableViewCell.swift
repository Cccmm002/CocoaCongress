//
//  LegisDetailTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/15/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

struct detailTableData {
    var title : String
    var content : String
    var clickable : Bool
    
    init(title: String, content: String?, click: Bool) {
        self.title = title
        if let c = content {
            self.content = c
        }
        else {
            self.content = ""
        }
        self.clickable = click
    }
}

class LegisDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    var linkUrl : String = ""
    
    class var identifier: String { return String.className(self) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createLink(url: String) {
        self.linkUrl = url
        let tap = UITapGestureRecognizer(target: self, action: #selector(LegisDetailTableViewCell.tapFunction))
        labelContent.isUserInteractionEnabled = true
        labelContent.addGestureRecognizer(tap)
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        let targetURL=URL(string: self.linkUrl)
        let application=UIApplication.shared
        application.open(targetURL!);
    }
    
}
