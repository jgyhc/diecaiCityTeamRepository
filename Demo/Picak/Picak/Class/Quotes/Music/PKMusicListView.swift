//
//  PKMusicListView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/10.
//

import UIKit
import SwiftyJSON
import Kingfisher

class PKMusicCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var flag: UIImageView!
    var btnActionClosure:((_ url:URL)->Void)?
    
    var json:JSON? {
        didSet {
            if let data = self.json {
                icon.kf.setImage(with: data["image"].url)
                name.text = data["title"].stringValue
                detail.text = data["auth"].stringValue
                duration.text = data["timelength"].stringValue
            }
        }
    }
    
    
    @IBAction func action_btn(_ sender: Any) {
        
        if let closure = btnActionClosure {
            closure(json!["mp4_file"].url!)
        }
    }
    
    
}

