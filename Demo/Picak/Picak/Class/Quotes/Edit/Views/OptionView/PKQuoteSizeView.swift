//
//  PKQuoteSizeView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/26.
//

import UIKit

class PKQuoteSizeView: PKQuoteBottomOptionView {

    private var collectionView:UICollectionView!
    private var selectedIndex = 0
    
    private let data:[PKQuoteSize] = [PKQuoteSize(whRatio: 9/16.0, title: "9:16", size: CGSize(width: 28, height: 49)),
                                      PKQuoteSize(whRatio: 16.0/9, title: "16:9", size: CGSize(width: 49, height: 28)),
                                      PKQuoteSize(whRatio: 1.0, title: "1:1", size: CGSize(width: 36, height: 36)),
                                      PKQuoteSize(whRatio: 4/3.0, title: "4:3", size: CGSize(width: 40, height: 30)),
                                      PKQuoteSize(whRatio: 3/4.0, title: "3:4", size: CGSize(width: 30, height: 40))]

    
    override init(presenter: PKQuotesPresenter) {
        super.init(presenter: presenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initUI() {
        super.initUI()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(PKQuoteSizeCell.self, forCellWithReuseIdentifier: "PKQuoteSizeCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.addSubview(collectionView)
    
        collectionView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn)
            make.right.equalTo(0)
            make.left.equalTo(backBtn.snp.right).offset(20)
            make.height.equalTo(50)
        }
    }
    
    func update() {
        collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
}

extension PKQuoteSizeView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PKQuoteSizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PKQuoteSizeCell", for: indexPath) as! PKQuoteSizeCell
        cell.label.text = indexPath.item == 0 ? "O" : data[indexPath.item - 1].title
        cell.label.layer.borderWidth = selectedIndex == indexPath.item ? 1 : 0
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        presenter.contentView.updateQuoteFilter(name: data[indexPath.item].type.rawValue)
        if indexPath.item == 0 {
            presenter.hwRatio = presenter.asset.hwRatio
        }else {
            presenter.hwRatio = 1 / data[indexPath.item - 1].whRatio
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let hwRatio = presenter.asset.hwRatio
            if (hwRatio > 1) {
                return CGSize(width: 49 / hwRatio, height: 49)
            }else {
                return CGSize(width: 49 , height: 49 * hwRatio)
            }
        }
        return data[indexPath.item - 1].size
    }
}
