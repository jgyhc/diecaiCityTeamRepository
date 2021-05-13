//
//  ORPublicTool.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/21.
//

import Foundation
import UIKit

class ORPublicTool: NSObject {
    
    public class func or_getSize(withImage image:UIImage, maxSize size:CGSize) -> CGSize {
        
        let ratio = image.size.width / image.size.height
        var endSize = CGSize.zero

        if ratio > size.width / size.height {
            endSize.width = size.width
            endSize.height = endSize.width / ratio
        } else {
            endSize.height = size.height
            endSize.width = endSize.height * ratio
        }
        return endSize
    }
    
    public class func or_getTimeString(time:TimeInterval) -> String {
        
        let duration = round(time)

        let min = Int(round(duration / 60))
        let sec = Int(duration - Double(min * 60))
        return String(format: "%02d:%02d", min,sec)
    }
    
}
