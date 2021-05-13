//
//  PKMusicController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/7.
//

import UIKit
import JXCategoryView
import MobileCoreServices

class PKMusicController: UIViewController {

    private let _categoryTitleView = JXCategoryTitleView()
    private var listContainerView:JXCategoryListContainerView!
    private let musicListVC:PKMusicListController = UIStoryboard(name: "Quotes", bundle: nil).instantiateViewController(identifier: "PKMusicListController") as! PKMusicListController

    private var controllers:[Any] = []
    private var titles:[String] = ["New","Video extraction"]

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let topBar = UIView()
        topBar.backgroundColor = UIColor.white
                
        let backBtn = UIButton(type: .custom)
        
        self.view.backgroundColor = UIColor.white
        
        listContainerView = JXCategoryListContainerView(type: .collectionView, delegate: self)
        listContainerView.listCellBackgroundColor = UIColor.white
        listContainerView.scrollView.backgroundColor = UIColor.white
        listContainerView.scrollView.isScrollEnabled = false

        _categoryTitleView.titleFont = UIFont.boldSystemFont(ofSize: 17)
        _categoryTitleView.titleSelectedColor = UIColor.black
        _categoryTitleView.titleColor = UIColor.lightGray
        _categoryTitleView.delegate = self
        _categoryTitleView.defaultSelectedIndex = 0
        _categoryTitleView.listContainer = listContainerView
        _categoryTitleView.titles = titles

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
        
    }
    
    @objc func backAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
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


extension PKMusicController: JXCategoryViewDelegate {
    
    func categoryView(_ categoryView: JXCategoryBaseView!, canClickItemAt index: Int) -> Bool {
        
        if index == 1 {
            
            musicListVC.pause()
            
            let vc = UIImagePickerController()
            vc.mediaTypes = [kUTTypeMovie as String]
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
}

extension PKMusicController: JXCategoryListContainerViewDelegate {
    
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return musicListVC
    }
    
}

extension PKMusicController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let videoUrl = info[.mediaURL] as? URL
//        self.performSegue(withIdentifier: "toQuotes", sender: nil);
        NotificationCenter.default.post(name: useAudioNotificationName, object: nil, userInfo: [useAudioNotificationAudioUrlKey : videoUrl!])
        
        picker.dismiss(animated: true) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }

    }
}
