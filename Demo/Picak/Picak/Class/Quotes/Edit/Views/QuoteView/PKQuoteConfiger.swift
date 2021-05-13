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
        
        /*
         
         CGFloat imageH = size.height;
         CGFloat imageW = size.width;
         CGFloat buttonRadius = NTWidthRatio(30);//实际25
         CGFloat angle = atan(imageW / imageH);
         CGFloat edgeW = buttonRadius * sin(angle);
         CGFloat edgeH = buttonRadius * cos(angle);
         CGRect outBounds = CGRectMake(0, 0, imageW + 2 * edgeW, imageH + 2 * edgeH);
         CGFloat max = [UIScreen mainScreen].bounds.size.width / 2.0f;
         CGFloat min = NTWidthRatio(60);
         CGFloat scaleRadio = 1.0f;
         if (imageW > imageH && imageW && imageW > max) {
             scaleRadio = max / imageW;
             CGFloat scaleH = scaleRadio * imageH;
             if (scaleH < min) {
                 scaleRadio = min / imageH;
             }
         }
         if (imageH >= imageW && imageH > max) {
     //        if (_associateModel.type == XWWatermarkTemplateTypeText) {
     //            min = NTWidthRatio(30);
     //        }
             scaleRadio = max / imageH;
             CGFloat scaleW = scaleRadio * imageW;
             if (scaleW < min) {
                 scaleRadio = min / imageW;
             }
         }
         _outBounds = CGRectApplyAffineTransform(outBounds, CGAffineTransformMakeScale(scaleRadio, scaleRadio));
         _angleForDiagonal = angle;
         
         */
        
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
