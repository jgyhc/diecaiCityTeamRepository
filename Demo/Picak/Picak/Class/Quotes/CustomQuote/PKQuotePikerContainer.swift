//
//  PKQuotePikerContainer.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/27.
//

import UIKit

class PKQuotePikerContainer: UIView {

    let backBtn = UIButton(type: .custom)
    let pikerContainer = UIView()
    weak var presenter:PKQuoteCustomPresenter!
    
    init(presenter:PKQuoteCustomPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 1
        
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        backBtn.setTitle("Done", for: .normal)
        backBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.addTarget(self, action: #selector(self.backAction(sender:)), for: .touchUpInside)
        
//        pikerContainer.backgroundColor = UIColor.white
        
        self.addSubview(topView)
        topView.addSubview(backBtn)
        self.addSubview(pikerContainer)
    
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(44)
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-15)
        }
        
        pikerContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(44)
            make.bottom.equalTo(-12)
        }
    }
    
    @objc func backAction(sender:UIButton) {
        self.isHidden = true
    }
    
    
}
