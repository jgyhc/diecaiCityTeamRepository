//
//  PKQuoteSizeCell.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/26.
//

import Foundation
import SnapKit

class PKQuoteSizeCell: UICollectionViewCell {
    
//    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.nt_color(withHexString: "#3C3C3C")
//        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        
        self.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        label.frame = self.bounds
    }
}
