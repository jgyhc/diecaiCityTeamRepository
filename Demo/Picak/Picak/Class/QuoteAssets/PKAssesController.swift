//
//  PKAssesController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/28.
//

import UIKit
import JXCategoryView;


class PKAssesController: UIViewController {

    var canUse = false

    private let _categoryTitleView = JXCategoryTitleView()
    private var listContainerView:JXCategoryListContainerView!
    private var presenter:PKCategoriesPresenter!
    
    private var controllers:[Any] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let topBar = UIView()
        topBar.backgroundColor = UIColor.white
                
        let backBtn = UIButton(type: .custom)
        
        self.view.backgroundColor = UIColor.white
        
        listContainerView = JXCategoryListContainerView(type: .collectionView, delegate: self)
        listContainerView.listCellBackgroundColor = UIColor.white
        listContainerView.scrollView.backgroundColor = UIColor.white

        _categoryTitleView.titleFont = UIFont.boldSystemFont(ofSize: 17)
        _categoryTitleView.titleSelectedColor = UIColor.black
        _categoryTitleView.titleColor = UIColor.lightGray
        _categoryTitleView.delegate = self
        _categoryTitleView.defaultSelectedIndex = 0
        _categoryTitleView.listContainer = listContainerView

        backBtn.setImage(UIImage(named: "pk_back_dark"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.backAction(sender:)), for: .touchUpInside)

        self.view.addSubview(topBar)
        topBar.addSubview(_categoryTitleView)
        topBar.addSubview(backBtn)
        self.view.addSubview(listContainerView)

        backBtn.snp.makeConstraints { (make) in
            make.width.equalTo(36)
            make.left.top.bottom.equalTo(0)
        }
        _categoryTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(backBtn.snp.right).offset(6)
            make.right.top.bottom.equalTo(0)
        }
        topBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(0)
            make.height.equalTo(44)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.left.right.equalTo(0)
        }
        
        presenter = PKCategoriesPresenter(delegate: self)
        presenter.loadTypesData()
    }
    
    @objc func backAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PKAssesController: PKCategoriesPresenterDelegate {
    func update() {
        _categoryTitleView.titles = presenter.names
        _categoryTitleView.reloadData()
    }
}

extension PKAssesController: JXCategoryViewDelegate {
    
    func categoryView(_ categoryView: JXCategoryBaseView!, canClickItemAt index: Int) -> Bool {
        return true
    }
    
}

extension PKAssesController: JXCategoryListContainerViewDelegate {
    
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return presenter.names.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        
        let assetPresenter = PKAssetPresenter(id: presenter.ids[index])
        let vc = PKAssetsListController(presenter: assetPresenter)
        vc.canUse = canUse
        controllers.append(vc)
        return vc
    }
    
    
}
