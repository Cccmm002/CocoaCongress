//
//  LeftMenuTableViewCell.swift
//  CocoaCongress
//
//  Created by Cccmm002 on 11/19/16.
//  Copyright © 2016 Cccmm002. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    class var identifier: String { return String.className(self) }
    
    open class func height() -> CGFloat {
        return 44
    }
    
    func setData(menu: LeftMenu) {
        self.backgroundColor = UIColor(red: 226.0, green: 235.0, blue: 221.0, alpha: 1.0)
        //self.labelTitle.textColor = UIColor(hex: "9E9E9E")
        self.imageIcon.tintColor = UIColor(hex: "9E9E9E")
        switch menu {
        case .legis:
            self.imageIcon.image = UIImage(named: "User-96")!
            self.labelTitle.text = "Legislators"
        case .bill:
            self.imageIcon.image = UIImage(named: "File-100")!
            self.labelTitle.text = "Bills"
        case .com:
            self.imageIcon.image = UIImage(named: "Enter-104")!
            self.labelTitle.text = "Committees"
        case .fav:
            self.imageIcon.image = UIImage(named: "Star-100")!
            self.labelTitle.text = "Favorites"
        case .about:
            self.imageIcon.image = UIImage(named: "About-100")!
            self.labelTitle.text = "About"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
