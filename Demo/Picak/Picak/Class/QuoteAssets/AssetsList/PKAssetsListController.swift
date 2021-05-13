//
//  PKAssetsListController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/28.
//

import UIKit
import SnapKit
import JXCategoryView
import MJRefresh
import Kingfisher

class PKAssetsListController: UIViewController {

    var canUse = false

    private var collectionView:UICollectionView!
    private var presenter:PKAssetPresenter!
    
    init(presenter:PKAssetPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        presenter.attach(controller: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.        
        let layout = EWWaterFallLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(PKAssetCell.self, forCellWithReuseIdentifier: "PKAssetCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.presenter.refresh()
        })
        
        collectionView.mj_footer = ORLoadMoreFooter(refreshingBlock: {[weak self] in
            self?.presenter.loadMore()
        })
        
        self.view.addSubview(collectionView)
    
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        collectionView.mj_header.beginRefreshing()
        
    }
    


}

extension PKAssetsListController:PKAssetControllerProtocol {
    
    func update() {
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
        collectionView.reloadData()
    }
    
    func loadFailure() {
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
    }
    
    func endRefreshWithNoMoreData() {
        
    }
    
    
}

extension PKAssetsListController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PKAssetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PKAssetCell", for: indexPath) as! PKAssetCell
        let da = presenter.data[indexPath.item]
        cell.imageView.kf.setImage(with: da["image"].url)
        cell.label.text = da["title"].stringValue
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PKAssetPreviewController(data:presenter.data[indexPath.item])
        vc.canUse = canUse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PKAssetsListController:EWWaterFallLayoutDataSource {
    
    func waterFallLayout(_ waterFallLayout: EWWaterFallLayout!, heightForItemAtIndexPath indexPath: UInt, itemWidth: CGFloat) -> CGFloat {
        let da = presenter.data[Int(indexPath)]
        return itemWidth / CGFloat(da["scale"].floatValue) + 24
    }
    
    func columnCount(in waterFallLayout: EWWaterFallLayout!) -> UInt {
        return 2
    }
    
    func rowMargin(in waterFallLayout: EWWaterFallLayout!) -> CGFloat {
        return 10
    }
    
    func columnMargin(in waterFallLayout: EWWaterFallLayout!) -> CGFloat {
        return 10
    }
    
    func edgeInsets(in waterFallLayout: EWWaterFallLayout!) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}

extension PKAssetsListController: JXCategoryListContentViewDelegate {
    func listView() -> UIView! {
        return self.view
    }
    func listWillAppear() {
        print("list will appear")
    }
    
}
