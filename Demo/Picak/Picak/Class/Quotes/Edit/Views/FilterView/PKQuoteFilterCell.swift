//
//  PKQuoteFilterCell.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/25.
//

import UIKit
import SnapKit

class PKQuoteFilterCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.white
        label.text = "Transparency"
        
        imageView.layer.borderColor = UIColor.white.cgColor
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(-6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
