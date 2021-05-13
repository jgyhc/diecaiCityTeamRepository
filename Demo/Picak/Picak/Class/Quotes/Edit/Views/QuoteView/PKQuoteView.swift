//
//  PKQuoteView.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import UIKit

protocol PKQuoteViewDelegate:NSObject {
    func quoteWillEdit(quote:PKQuoteView)
    func quoteDidTap(quote:PKQuoteView)
}

extension PKQuoteViewDelegate {
    func quoteWillEdit(quote:PKQuoteView) {
        
    }
    func quoteDidTap(quote:PKQuoteView) {
        
    }
}

class PKQuoteView: UIView {


    private let borderView = PKQuoteBorderView()
    private let topRBtn = UIButton(type: .custom)

    private var maxSize = CGSize(width: 100, height: 100)
    private var config:PKQuoteConfig?

    private var angle:CGFloat = 0;
    private var isUpright = false
    
    weak var delegate:PKQuoteViewDelegate?
    
    let imageView = UIImageView()
    
    var selected:Bool {
        set {
            borderView.isHidden = !newValue
            topRBtn.isHidden = !newValue
        }
        get {
            return !borderView.isHidden
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withImage image:UIImage, maxSize size:CGSize) {
        super.init(frame: CGRect.zero)
        
        
        maxSize = size
        self.addSubview(borderView)
        self.addSubview(imageView)
        self.addSubview(topRBtn)
//        topRBtn.backgroundColor = UIColor.red
        topRBtn.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        topRBtn.setImage(UIImage(named: "quotes_edit"), for: .normal)

        updateQuote(image: image)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.action_tap(gesture:)))
        self.addGestureRecognizer(tapGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.action_rotation(gesture:)))
        self.addGestureRecognizer(rotationGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.action_pinch(gesture:)))
        self.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.action_pan(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        topRBtn.addTarget(self, action: #selector(self.action_topR(sender:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if let _config = config  {
            
            let buttonRadius:CGFloat = 30
            let bounds = self.bounds
            
            
            borderView.frame = bounds.insetBy(dx: buttonRadius * 0.5 * sin(_config.angle), dy: buttonRadius * 0.5 * cos(_config.angle))
            
            imageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width - 2 * _config.edgeW, height: self.bounds.size.height - 2 * _config.edgeH)
            imageView.center = CGPoint(x:bounds.width / 2.0, y:bounds.height / 2.0)
            topRBtn.center = CGPoint(x: borderView.frame.maxX, y: borderView.frame.minY)
        }

    }

    func updateQuote(image:UIImage) {
        
        imageView.image = image
        selected = true
        config = PKQuoteConfiger.getConfig(withImageSize: image.size, max: min(maxSize.width, maxSize.height), buttonRadis: 30)

        if let _config = config  {
            self.bounds = _config.bounds
        }
//        let endSize = ORPublicTool.or_getSize(withImage: image, maxSize: maxSize)
//        let inset = PKQuoteSideView.sideWidth
//        self.bounds = CGRect(x: 0, y: 0, width: endSize.width, height: endSize.height)
//        imageView.image = image
//        imageView.bounds = CGRect(x: 0, y: 0, width: endSize.width - inset, height: endSize.height - inset)
//
        
        
    }
    
        
}

//MARK: - action
extension PKQuoteView {
    
    @objc private func action_topR(sender:UIButton) {
        if let d = delegate {
            d.quoteDidTap(quote: self)
        }
    }
    
    @objc private func action_tap(gesture:UITapGestureRecognizer) {
        willEdit()
//        if let d = delegate {
//            d.quoteDidTap(quote: self)
//        }
    }
    
    @objc private func action_pinch(gesture:UIPinchGestureRecognizer) {
        switch (gesture.state) {
        case .began: willEdit()
        case .changed: do {
            let min:CGFloat = 50.0
            if (imageView.bounds.width > min && imageView.bounds.height > min) || gesture.scale > 1.0  {
//                imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                imageView.transform = .identity
                self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width * gesture.scale, height: self.bounds.height * gesture.scale)
            }
            gesture.scale = 1
        }
        default: break;
        }
    }
    
    @objc private func action_rotation(gesture:UIRotationGestureRecognizer) {
        switch (gesture.state) {
        case .began: willEdit()
        case .changed: do {
            angle += gesture.rotation
            
            let transformZ:NSNumber =  (self.layer.value(forKeyPath: "transform.rotation.z") ?? NSNumber(0.0)) as! NSNumber
            let rotation = transformZ.doubleValue + Double(angle)
//            print(transformZ.doubleValue)
            if ((rotation > -0.05 && rotation < 0.05) || (rotation > -3.20 && rotation < -3.09)) {
                
                if (rotation > -0.05 && rotation < 0.05) {
                    self.layer.setValue(NSNumber(0.0), forKeyPath: "transform.rotation.z")
                }else if (rotation > -3.20 && rotation < -3.08) {
                    self.layer.setValue(NSNumber(-3.14), forKeyPath: "transform.rotation.z")
                }
                
                if isUpright == false {
                    isUpright = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                
            }else {
                self.transform = self.transform.rotated(by: angle)
                angle = 0
                isUpright = false
            }
            gesture.rotation = 0
        }
        default: break;
        }
    }
    
    @objc private func action_pan(gesture:UIPanGestureRecognizer) {
        switch (gesture.state) {
        case .began: willEdit()
        case .changed: do {
            let translation = gesture.translation(in: self.superview)
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            gesture.setTranslation(.zero, in: gesture.view)
        }
            default: break;
        }
    }
    
    private func willEdit() {
        if let d = delegate {
            d.quoteWillEdit(quote: self)
        }
        selected = true
    }
}

