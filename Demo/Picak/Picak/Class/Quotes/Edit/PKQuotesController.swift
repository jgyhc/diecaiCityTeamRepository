//
//  PKQuotesController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/19.
//

import UIKit
import SnapKit
import MobileCoreServices
import SVProgressHUD
import StoreKit

class PKQuotesController: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var bottomContentView: UIView!
    @IBOutlet weak var bottomContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomContentViewBottom: NSLayoutConstraint! // 200
    
    private var _contentView:PKQuotesContentView!
    private var _timeLineView:PKQuotesTimelineView!
    private let _presenter = PKQuotesPresenter()
    private var _quoteOptionView:PKQuoteOptionView!
    private var _quoteFilterView:PKQuoteFilterView!
    private var _quoteSizeView:PKQuoteSizeView!
    private lazy var _cropView:ORPhotoCropView! = ORPhotoCropView()

    public var imageUrl:URL?
    public var videoUrl:URL?
    
    deinit {
        print("PKQuotesController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            SKStoreReviewController.requestReview()
        }
        
        _presenter.attach(controller: self)
        _pk_initView()
        _presenter.config(imageUrl: imageUrl, assetUrl: videoUrl)
    }
    
    private func _pk_initView() {
        
        _timeLineView = PKQuotesTimelineView(presenter: _presenter)
        _contentView = PKQuotesContentView(presenter: _presenter)
        _quoteOptionView = PKQuoteOptionView(presenter: _presenter)
        _quoteOptionView.isHidden = true
        _quoteFilterView = PKQuoteFilterView(presenter: _presenter)
        _quoteFilterView.isHidden = true
        _quoteSizeView = PKQuoteSizeView(presenter: _presenter)
        _quoteSizeView.isHidden = true
        
        mainContentView.addSubview(_contentView)
        mainContentView.addSubview(_timeLineView)
        bottomContentView.addSubview(_quoteOptionView)
        bottomContentView.addSubview(_quoteFilterView)
        bottomContentView.addSubview(_quoteSizeView)

        _timeLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        _contentView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(_timeLineView.snp.top)
        }
        _quoteOptionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(64)
        }
        _quoteSizeView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(64)
        }
        _quoteFilterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(150)
        }
        
        _cropView.didCropImage = {[weak self](image) in
            self?._contentView.updateQuote(image: image)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.action_save))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:PKQuoteCustomController = segue.destination as! PKQuoteCustomController
        vc.useQuoteClosure = {[weak self](image:UIImage) in
            self?._contentView.updateQuote(image: image)
        }
    }

    // MARK: - Action
    @IBAction func action_music(_ sender: Any) {
        let vc = PKMusicController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func action_quotes(_ sender: Any) {
        showBottomContentView(height: 88, subView: _quoteOptionView)
    }
    @IBAction func action_size(_ sender: Any) {
        showBottomContentView(height: 88, subView: _quoteSizeView)
    }
    
    @objc private func action_save() {
        SVProgressHUD.setDefaultMaskType(.black)
        _presenter.save()
    }
    
    private func showBottomContentView(height:CGFloat, subView:UIView) {
        
        if bottomContentViewBottom.constant == 0 {
            return
        }
        subView.isHidden = false
        bottomContentView.subviews.forEach { (view) in
            if view != subView {
                view.isHidden = true
            }
        }
        bottomContentViewBottom.constant = -10
        bottomContentViewHeight.constant = height
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PKQuotesController:PKQuotesControllerProtocol {
    func hideHud() {
        SVProgressHUD.dismiss()
    }
    func exportSuccess() {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.dismiss()
        self.or_showOnlySureAlert("Save success", message: "Successfully saved to album") {
            SKStoreReviewController.requestReview()
        }
        
    }
    func exportHud(progress: Float) {
        SVProgressHUD.showProgress(progress, status: String(Int(progress * 100)) + "%")
    }
    func update() {
        self.hideHud()
        _quoteSizeView.update()
    }
    func hideBottom() {
        bottomContentViewBottom.constant = bottomContentViewHeight.constant + 40
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        _contentView.unSelectQuote()
    }
    func selectQuoteOption(type: PKQuoteSelectOption) {
        switch type {
        case .local: do {
            hideBottom()
            let vc = UIImagePickerController()
            vc.mediaTypes = [kUTTypeImage as String]
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        case .custom: do {
            hideBottom()
            self.performSegue(withIdentifier: "custom", sender: nil)
        }
            
        default: do {
            let asset = PKAssesController()
            asset.canUse = true
            self.navigationController?.pushViewController(asset, animated: true)
        }
            
        }
    }
    func showFilterView() {
        hideBottom()
        showBottomContentView(height: 150, subView: _quoteFilterView)
    }
    func showCropView() {
        _cropView.or_setUpUI(with: _contentView.image!)
        _cropView.or_show()
    }
}

extension PKQuotesController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let url = info[.imageURL] as? URL
        _presenter.updateQuote(imageUrl: url!)
    }
}
