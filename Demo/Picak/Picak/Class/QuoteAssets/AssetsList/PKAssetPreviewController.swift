//
//  PKAssetPreviewController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/30.
//

import UIKit
import SnapKit
import SwiftyJSON
import Kingfisher

class PKAssetPreviewController: UIViewController {

    var canUse = false

    let imageView = UIImageView()
    var data:JSON!
    
    init(data:JSON) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black
        
        imageView.contentMode = .scaleAspectFit;
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let url = URL(string: data["image"].stringValue)
        imageView.kf.setImage(with: url)
        
        if canUse {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .plain, target: self, action: #selector(self.action_use))
        }
        
    }
    
    @objc private func action_use() {
        NotificationCenter.default.post(name: useImageNotificationName, object: nil, userInfo: [useImageNotificationImageUserInfoKey : imageView.image!])
        
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        
//        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
