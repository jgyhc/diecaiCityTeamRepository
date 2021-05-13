//
//  PKQuoteSourcePicker.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/27.
//

import UIKit

class PKQuoteSourcePicker: PKQuotePikerContainer {

    private let picker = UIPickerView()
    private let data:[String] = ["Twitter for iPhone", "Twitter for Android", "Twitter Web App", "None"]
    private var currentIndex = 0

    override func initUI() {
        super.initUI()
        
        picker.delegate = self
        picker.dataSource = self
        pikerContainer.addSubview(picker)
        
        picker.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override func backAction(sender: UIButton) {
        super.backAction(sender: sender)
        presenter.controller.changeSource(source: data[currentIndex])
    }

}

extension PKQuoteSourcePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
    }
}
