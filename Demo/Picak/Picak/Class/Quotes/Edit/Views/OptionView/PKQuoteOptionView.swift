//
//  PKQuoteOptionView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/25.
//

import UIKit
import JXCategoryView;

class PKQuoteOptionView: PKQuoteBottomOptionView {

    private let _categoryTitleView = JXCategoryTitleView()
    
    override init(presenter: PKQuotesPresenter) {
        super.init(presenter: presenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUI() {
        super.initUI()
        
        _categoryTitleView.titleFont = UIFont.boldSystemFont(ofSize: 17)
        _categoryTitleView.titleSelectedColor = UIColor.white
        _categoryTitleView.titleColor = UIColor.white
        _categoryTitleView.delegate = self
        _categoryTitleView.isAverageCellSpacingEnabled = false

        _categoryTitleView.titles = ["Library", "Custom", "Gallery"];
     
        self.addSubview(_categoryTitleView)
        
        _categoryTitleView.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.left.equalTo(backBtn.snp.right).offset(10)
            make.centerY.equalTo(backBtn)
            make.height.equalTo(40)
        }
    }

}

extension PKQuoteOptionView: JXCategoryViewDelegate {
    
    func categoryView(_ categoryView: JXCategoryBaseView!, canClickItemAt index: Int) -> Bool {
        presenter.controller.selectQuoteOption(type: PKQuoteSelectOption(rawValue: index)!)
        return false
    }
    
}
