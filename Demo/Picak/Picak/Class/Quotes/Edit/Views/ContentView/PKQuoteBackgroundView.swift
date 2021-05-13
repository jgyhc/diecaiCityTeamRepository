//
//  PKQuoteBackgroundView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit
import AVFoundation

class PKQuoteBackgroundView: UIView {

    private let _scrollView = UIScrollView()
    
    let imageView = UIImageView()
    let playerLayer = AVPlayerLayer()

    private var _hwRatio:CGFloat = 1
    var hwRatio:CGFloat {
        get {
            return _hwRatio
        }
        set {
            if _hwRatio != newValue {
                _hwRatio = newValue
                if self.bounds.width > 0 {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _scrollView.delegate = self
        _scrollView.contentInsetAdjustmentBehavior = .never
        _scrollView.bounces = false
        self.addSubview(_scrollView)
        
        _scrollView.layer.addSublayer(playerLayer)
        _scrollView.addSubview(imageView)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _scrollView.frame = self.bounds
        if hwRatio <= 0 {
            return
        }
        
        var height:CGFloat, width:CGFloat
        
        if hwRatio < self.bounds.height / self.bounds.width {
            height = self.bounds.height
            width = height / hwRatio
        }else {
            width = self.bounds.width
            height = width * hwRatio
        }
        
        _scrollView.contentSize = CGSize(width: width, height: height)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height);
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = imageView.frame
        CATransaction.commit()
    }
    
}

extension PKQuoteBackgroundView: UIScrollViewDelegate {
    
}
