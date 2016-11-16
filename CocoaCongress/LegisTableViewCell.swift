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
    var chamber: String
    var first_name: String
    var last_name: String
    var state: String
    var image: UIImage?
    
    init(id: String, fname: String, lname: String, state: String, chamber: String) {
        self.id=id
        self.first_name=fname
        self.last_name=lname
        self.state=state
        self.image=nil
        self.chamber=chamber
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
    
    open class func height() -> CGFloat {
        return 50
    }
    
    func setData(_ data: Any?) {
        if let data = data as? LegisTableData {
            self.dataName.text = data.first_name + " " + data.last_name
            self.dataState.text = data.state
            
            if data.image == nil {
                let imgUrl : String = Constants.LegImgServer + data.id + ".jpg"
                if let checkedUrl = URL(string: imgUrl) {
                    self.downloadImage(url: checkedUrl)
                }
            }
            else {
                self.dataImage.image = data.image
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.dataImage.frame = CGRect(x:0, y:0, width:42, height:50)
                self.dataImage.contentMode = .scaleToFill
                self.dataImage.image = UIImage(data: data)
            }
        }
    }
    
}
