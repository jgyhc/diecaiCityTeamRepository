//
//  PKQuoteDatePicker.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/27.
//

import UIKit

class PKQuoteDatePicker: PKQuotePikerContainer {

    private let picker = UIDatePicker()
    
    override func initUI() {
        super.initUI()
        
        pikerContainer.addSubview(picker)
        
        picker.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override func backAction(sender: UIButton) {
        super.backAction(sender: sender)
        presenter.controller.changeDate(date: picker.date)
    }

}
