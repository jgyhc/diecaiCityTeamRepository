//
//  PKQuoteCustomController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/20.
//

import UIKit
import CoreGraphics
import SVProgressHUD
import MobileCoreServices
import Cache

class PKQuoteCustomController: UITableViewController {

    var useQuoteClosure:((_ image:UIImage)->Void)!
    
    @IBOutlet weak var headIcon: UIImageView!
    @IBOutlet weak var usernameFiled: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var bgSwitch: UISwitch!
    @IBOutlet weak var wordTextView: UITextView!
    
    private let _presenter = PKQuoteCustomPresenter()
    private var _datePicker:PKQuoteDatePicker!
    private var _sourcePicker:PKQuoteSourcePicker!
    private var _imageView:UIImageView!

    var cache:Storage<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        wordTextView.superview?.or_addRoundedCorners(.allCorners, 16)
        bgSwitch.superview?.or_addRoundedCorners(.allCorners, 16)
//        bgSwitch.superview?.or_addRoundedCorners([.bottomLeft,.bottomRight], 16)
//        timeLabel.superview?.or_addRoundedCorners([.topLeft,.topRight], 16)
        idField.superview?.or_addRoundedCorners([.bottomLeft,.bottomRight], 16)
        headIcon.superview?.or_addRoundedCorners([.topLeft,.topRight], 16)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .plain, target: self, action: #selector(self.action_use))
        
        _presenter.attach(controller: self)
        _datePicker = PKQuoteDatePicker(presenter: _presenter)
        _datePicker.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 208)
        _datePicker.isHidden = true
        self.tableView.addSubview(_datePicker)
        
        _sourcePicker = PKQuoteSourcePicker(presenter: _presenter)
        _sourcePicker.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 208)
        _sourcePicker.isHidden = true
        self.tableView.addSubview(_sourcePicker)
        
        
        let diskConfig = DiskConfig(name: "com.picak.custom_quote")
        let memoryConfig = MemoryConfig()
        
        self.cache = try? Storage<String, String>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: String.self) // Storage<String, User>
        )
        readCache()
    }
    
    private func readCache() {
        
        let boolStorage = self.cache.transformCodable(ofType: Bool.self)
        let didSave = try? boolStorage.object(forKey: "didSave")
        if didSave == false || didSave == nil {
            return
        }
                
        self.usernameFiled.text = try? self.cache.object(forKey: "username")
        self.idField.text = try? self.cache.object(forKey: "id")
//        self.timeLabel.text = try? self.cache.object(forKey: "time")
//        self.sourceLabel.text = try? self.cache.object(forKey: "source")
        self.wordTextView.text = try? self.cache.object(forKey: "word")
        self.bgSwitch.isOn = try! boolStorage.object(forKey: "bg")
        
        let imageStorage = self.cache.transformImage()
        self.headIcon.image = try? imageStorage.object(forKey: "headIcon")
    }
    
    private func saveCache() {
        let boolStorage = self.cache.transformCodable(ofType: Bool.self)
        let imageStorage = self.cache.transformImage()
        
        try? boolStorage.setObject(true, forKey: "didSave")
        try? boolStorage.setObject(self.bgSwitch.isOn, forKey: "bg")
        try? imageStorage.setObject(headIcon.image!, forKey: "headIcon")

        try? self.cache.setObject(self.usernameFiled.text!, forKey: "username")
        try? self.cache.setObject(self.idField.text!, forKey: "id")
//        try? self.cache.setObject(self.timeLabel.text!, forKey: "time")
//        try? self.cache.setObject(self.sourceLabel.text!, forKey: "source")
        try? self.cache.setObject(self.wordTextView.text!, forKey: "word")

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = UIImagePickerController()
            vc.mediaTypes = [kUTTypeImage as String]
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true, completion: nil)
            return
        }
        
//        if indexPath.section == 1  {
//            let cell = tableView.cellForRow(at: indexPath)
//            if indexPath.row == 0 {
//                UIView.animate(withDuration: 0.25) { [self] in
//                    self._sourcePicker.isHidden = true
//                    self._datePicker.isHidden = false
//                    self._datePicker.frame.origin.y = (cell?.frame.minY)! - 10 - self._datePicker.frame.height
//                }
//            } else if indexPath.row == 1 {
//                UIView.animate(withDuration: 0.25) { [self] in
//                    self._datePicker.isHidden = true
//                    self._sourcePicker.isHidden = false
//                    self._sourcePicker.frame.origin.y = (cell?.frame.minY)! - 10 - self._sourcePicker.frame.height
//                }
//            }
//        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
    
    
    @objc private func action_use() {
        
        guard self.wordTextView.text.count != 0 else {
            SVProgressHUD.showError(withStatus: "input word")
            return
        }
        
        guard self.usernameFiled.text?.count != 0 else {
            SVProgressHUD.showError(withStatus: "input name")
            return
        }
        
        guard self.idField.text?.count != 0 else {
            SVProgressHUD.showError(withStatus: "input id")
            return
        }
        
        let text:NSString = self.wordTextView.text as NSString
        let nickName:NSString = self.usernameFiled.text! as NSString
        let id:NSString = self.idField.text! as NSString
//        let time:NSString = self.timeLabel.text! as NSString
//        let source:NSString = self.sourceLabel.text! as NSString
        let headImage:UIImage = self.headIcon.image!.or_allCorner()
        
        let isBlack = self.bgSwitch.isOn;
        
        let queue = DispatchQueue(label: "com.customQuoteExport.pk")
        queue.async {
            let textWidth = 345.0
            
//            var drawHeadIcon:UIImage!
//            if headImage.size.height == headImage.size.width {
//                drawHeadIcon = headImage.or_allCorner()
//            }else {
//                let width = min(headImage.size.width, headImage.size.height)
//                drawHeadIcon = headImage.nt_imageByResize(toAspectFill: CGSize(width: width, height: width))?.or_allCorner()
//            }
            
            
            
//            let moreImage = UIImage(named: "quotes_more")
            
            var fillColor:UIColor!, mainTextColor:UIColor!, grayTextColor:UIColor!
            if isBlack {
                fillColor = UIColor.black
                mainTextColor = UIColor.white
                grayTextColor = UIColor.lightGray
            }else {
                fillColor = UIColor.white
                mainTextColor = UIColor.black
                grayTextColor = UIColor.darkGray
            }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            
            let height:Double! = Double(text.boundingRect(with: CGSize(width: textWidth, height: 600), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), NSAttributedString.Key.paragraphStyle : paragraphStyle], context: nil).size.height)
            
    //        UIGraphicsBeginImageContext(CGSize(width: textWidth, height: height))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 375, height: height + 110), true, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(fillColor.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: 375, height: height + 112))
            
            //I don't know why
            headImage.draw(in: CGRect(x: 15, y: 15, width: 44, height: 47))
//            moreImage!.draw(in: CGRect(x: 342, y: 15, width: 18, height: 18))

            nickName.draw(at: CGPoint(x: 67, y: 22), withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13),NSAttributedString.Key.foregroundColor : mainTextColor!])
            id.draw(at: CGPoint(x: 67, y: 40), withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : grayTextColor!])
            text.draw(in:CGRect(x: 15, y: 78, width: textWidth, height: height), withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor : mainTextColor!, NSAttributedString.Key.paragraphStyle : paragraphStyle])

//            time.draw(at: CGPoint(x: 15, y: 81 + height), withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : grayTextColor!])
//            if source != "None" {
//                source.draw(at: CGPoint(x: 129, y: 81 + height), withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : mainTextColor!])
//            }

            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndPDFContext()
            
            DispatchQueue.main.async {
                self.saveCache()
                self.useQuoteClosure(image!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension PKQuoteCustomController:PKQuoteCustomControllerProtocol {
    
    func changeDate(date: Date) {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:m aa M/d/yy"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    func changeSource(source: String) {
        sourceLabel.text = source
    }
    
}

extension PKQuoteCustomController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        let width = min(image.size.width, image.size.height)
        
        let new = image.nt_imageByResize(toAspectFill: CGSize(width: width, height: width))
        headIcon.image = new
    }
}
