//
//  PKAssetCell.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/28.
//

import UIKit
import SnapKit
import Kingfisher

class PKAssetCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
        }
        imageView.nt_roundedCorner(withRadius: 16, cornerColor: UIColor.white)
        label.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
