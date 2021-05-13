//
//  PKMineController.swift
//  Picak
//
//  Created by OrangesAL on 2021/5/5.
//

import UIKit
import Kingfisher
import SVProgressHUD

class PKMineController: UITableViewController {

    @IBOutlet weak var headIcon: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var cacheLabel: UILabel!
    
    @IBOutlet weak var sectionTopView: UIView!
    @IBOutlet weak var sectionBottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableFooterView = UIView()
        
        sectionBottomView.or_addRoundedCorners([.bottomLeft,.bottomRight], 16)
        sectionTopView.or_addRoundedCorners([.topLeft,.topRight], 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserInfo), name: LoginChangedNotificationName, object: nil)
        
        self.updateUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            switch indexPath.item {
            case 0:
                UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1501118224?action=write-review")!, options: [.universalLinksOnly:false], completionHandler: nil)
            case 1: do {
                
                let image = UIImage(named: "logo")
                UIActivityViewController.gx_show(withTitle: "Picak", image: image, url: "itms-apps://itunes.apple.com/app/id1501118224?action=write-review", completeHandler: nil)
            }
            case 2:
                UIApplication.shared.open(URL(string: "instagram://user?username=iedit_app")!, options: [.universalLinksOnly:false]) { (success) in
                    if (!success) {
                        SVProgressHUD.showError(withStatus: "Please install instagram first")
                    }
                }
            case 3: do {
                let vc = FEWebViewController.fe_webNavgationController(withTitle: "service", webUrl: "http://picak.flyingeffect.com/picak/agree.html")
                self.present(vc, animated: true, completion: nil)
            }
            case 4: do {
                let vc = FEWebViewController.fe_webNavgationController(withTitle: "privacy", webUrl: "http://picak.flyingeffect.com/picak/privac.html")
                self.present(vc, animated: true, completion: nil)
            }
            default: break
                
            }
            

        }
    }
    
    @objc func updateUserInfo()  {
        let image = UIImage(named: "logo")
        
        headIcon.image = image
        idLabel.text = " "
        nickname.text = "Picak"
        
//        if PKUserService.shared.isLogin {
//            headIcon.kf.setImage(with: PKUserService.shared.userInfo?.url, placeholder: image)
//            nickname.text = PKUserService.shared.nickname
//            idLabel.text = PKUserService.shared.userID
//        }else {
//            headIcon.image = image
//            idLabel.text = "picak"
//            nickname.text = "Picak"
//        }
        
    }
}
