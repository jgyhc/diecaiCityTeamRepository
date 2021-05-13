//
//  PKQuoteOptionView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/25.
//

import UIKit

class PKQuoteBottomOptionView: UIView {

    let backBtn = UIButton(type: .custom)

    weak var presenter:PKQuotesPresenter!
    
    init(presenter:PKQuotesPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        
        backBtn.setImage(UIImage(named: "pk_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.backAction(sender:)), for: .touchUpInside)
        self.addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 22, height: 32))
        }
        
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor.nt_color(withHexString: "#323232")
        
    }
    
    @objc func backAction(sender:UIButton) {
        presenter.controller.hideBottom()
    }
    
}
