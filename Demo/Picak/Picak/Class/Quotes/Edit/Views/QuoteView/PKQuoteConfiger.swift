//
//  PKQuoteConfiger.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/11.
//

import UIKit

struct PKQuoteConfig {
    var bounds:CGRect!
    var angle:CGFloat!
    var edgeW:CGFloat!
    var edgeH:CGFloat!
}

class PKQuoteConfiger: NSObject {

    class func getConfig(withImageSize size:CGSize, max:CGFloat, buttonRadis:CGFloat) -> PKQuoteConfig? {
        
        let imageH = size.height
        let imageW = size.width
        
        if imageW == 0 || imageH == 0 {
            return nil
        }
        
        let angle = atan(imageW / imageH)
        let edgeW = buttonRadis * sin(angle)
        let edgeH = buttonRadis * cos(angle)
        var outBounds = CGRect(x: 0, y: 0, width: imageW + edgeW * 2, height: imageH + edgeH * 2)
        let min:CGFloat = 60
        var scaleRadio:CGFloat = 1.0
        
        if (imageW > imageH && imageW > max) {
            scaleRadio = max / imageW;
            if (scaleRadio * imageH < min) {
                scaleRadio = min / imageH;
            }
        }
        
        if (imageH >= imageW && imageH > max) {
            scaleRadio = max / imageH;
            if (scaleRadio * imageW < min) {
                scaleRadio = min / imageW;
            }
        }
        
        outBounds = outBounds.applying(CGAffineTransform(scaleX: scaleRadio, y: scaleRadio))
        
        return PKQuoteConfig(bounds: outBounds, angle: angle, edgeW: edgeW, edgeH: edgeH)
        
    }
    
}
