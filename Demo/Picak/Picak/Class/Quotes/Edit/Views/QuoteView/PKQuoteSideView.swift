//
//  PKQuoteSideView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit

enum PKQuoteSide {
    case top
    case bottom
    case right
    case left
}

class PKQuoteSideView: UIView {
        
    private let view = UIView()
    private var side:PKQuoteSide = .top
    
    class var sideWidth:CGFloat {
        return 10
    }
    
    init(withSide side:PKQuoteSide) {
        super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.side = side
        view.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.backgroundColor = UIColor.white
        self.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let width = view.bounds.width
        
        switch side {
        case .top:
            view.center.x = bounds.width / 2.0
            view.frame.origin.y = 0
        case .bottom:
            view.center.x = bounds.width / 2.0
            view.frame.origin.y = bounds.height - width
        case .right:
            view.center.y = bounds.height / 2.0
            view.frame.origin.x = bounds.width - width
        case .left:
            view.center.y = bounds.height / 2.0
            view.frame.origin.x = 0
        }        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PKQuoteBorderView: UIView {
    
    let border:CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(border)
        border.strokeColor = UIColor.white.cgColor;
        border.fillColor = nil
        border.lineWidth = 1
        border.lineCap = .square
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
    }

    
}

