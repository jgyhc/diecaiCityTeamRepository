//
//  ViewController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/15.
//

import UIKit
import MobileCoreServices

class PKHomeController: UIViewController {

    let datas = [
//        PKHomeModule(type: .excerpt, imageName: "home_excerpt"),
        PKHomeModule(type: .quotes, imageName: "home_quotes"),
    ]
    var imageUrl:URL?
    var videoUrl:URL?
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:PKQuotesController = segue.destination as! PKQuotesController
        vc.imageUrl = imageUrl
        vc.videoUrl = videoUrl
    }

}

extension PKHomeController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PKHomeCollectionViewCell", for: indexPath) as! PKHomeCollectionViewCell
        cell.module = datas[indexPath.item]
        
        if cell.btnActionClosure == nil {
            cell.btnActionClosure = {[weak self] in
                let asset = PKAssesController()
                asset.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(asset, animated: true)
            }
        }
        
        return cell
    }
}

extension PKHomeController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIImagePickerController()
        vc.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension PKHomeController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width * 0.4
        return CGSize(width: width, height: width * 12 / 17.0)
    }
}

extension PKHomeController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageUrl = info[.imageURL] as? URL
        videoUrl = info[.mediaURL] as? URL
        self.performSegue(withIdentifier: "toQuotes", sender: nil);
    }
}

class PKHomeCollectionViewCell: UICollectionViewCell {
    
    var btnActionClosure:(()->Void)?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func action_btn(_ sender: Any) {
        
        if let closure = btnActionClosure {
            closure()
        }
    }
    
    var module:PKHomeModule! {
        didSet {
            imageView.image = UIImage(named: module.imageName)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

