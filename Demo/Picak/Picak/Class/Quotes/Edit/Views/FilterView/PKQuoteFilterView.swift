//
//  PKQuoteFilterView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/25.
//

import UIKit

class PKQuoteFilterView: UIView {

    private let finishBtn = UIButton(type: .custom)
    private let slider = UISlider()
    private var collectionView:UICollectionView!
    private var selectedIndex = 0

    private let data:[PKQuoteFilter] = [PKQuoteFilter(type: .normalBlendMode, imageName: "quotes_filter_normal", title: "Normal"),
                                        PKQuoteFilter(type: .multiplyBlendMode, imageName: "quotes_filter_mutiply", title: "White"),
                                        PKQuoteFilter(type: .colorDodgeBlendMode, imageName: "quotes_filter_colorDodge", title: "Dark"),
                                        ]

    private weak var presenter:PKQuotesPresenter!
    
    init(presenter:PKQuotesPresenter) {
        super.init(frame: CGRect.zero)
        self.presenter = presenter
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        
        self.backgroundColor = UIColor.nt_color(withHexString: "#323232")

        let image = UIImage(named: "pk_thumb")
        slider.setThumbImage(image, for: .normal)
        slider.setThumbImage(image, for: .highlighted)
        slider.externalTouchInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        
        finishBtn.setImage(UIImage(named: "pk_ok"), for: .normal)
        finishBtn.addTarget(self, action: #selector(self.action_back(sender:)), for: .touchUpInside)
        
        slider.addTarget(self, action: #selector(self.action_slider(sender:)), for: .valueChanged)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 64, height: 64)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(PKQuoteFilterCell.self, forCellWithReuseIdentifier: "PKQuoteFilterCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.addSubview(slider)
        self.addSubview(collectionView)
        self.addSubview(finishBtn)
        
        finishBtn.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.size.equalTo(CGSize(width: 48, height: 50))
        }
        slider.snp.makeConstraints { (make) in
            make.right.equalTo(finishBtn.snp.left).offset(-10)
            make.centerX.equalTo(self)
            make.centerY.equalTo(finishBtn)
        }
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.left.right.equalTo(0)
            make.height.equalTo(64)
        }
    }
    
    @objc func action_back(sender:UIButton) {
        presenter.controller.hideBottom()
    }
    
    @objc func action_slider(sender:UISlider) {
        presenter.contentView.updateQuoteAlpha(alpha: 1-CGFloat(sender.value))
    }

}

extension PKQuoteFilterView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PKQuoteFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PKQuoteFilterCell", for: indexPath) as! PKQuoteFilterCell
        cell.imageView.image = UIImage(named: data[indexPath.item].imageName)
        cell.label.text = data[indexPath.item].title
        cell.imageView.layer.borderWidth = selectedIndex == indexPath.item ? 1 : 0
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.contentView.updateQuoteFilter(name: data[indexPath.item].type.rawValue)
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}
