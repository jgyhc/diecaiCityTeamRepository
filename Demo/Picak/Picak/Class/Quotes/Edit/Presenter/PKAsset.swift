//
//  PKAsset.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/22.
//

import UIKit
import AVFoundation

class PKAsset: NSObject {
    
    private(set) var asset:AVAsset?
    private(set) var image:UIImage?
    var beginTime:CMTime = CMTime.zero
    var endTime:CMTime = CMTime(value: 6000, timescale: 600)
    private(set) var assetDuration:CMTime = CMTime(value: 6000, timescale: 600)

    var duration:CMTime {
        return endTime - beginTime
    }
    
    private(set) var size:CGSize!
    private(set) var hwRatio:CGFloat = 1
    
    init(assetUrl:URL) {
        super.init()
        
        asset = AVAsset(url: assetUrl)
        
        if let a = asset {
            assetDuration = a.duration
            endTime = assetDuration
            size = FEVideoCommonService.fe_size(with: a)
            hwRatio = size.height / size.width
        }
    }
    init(imageUrl:URL) {
        super.init()

        image = UIImage(contentsOfFile: imageUrl.path)
        size = image?.size
        hwRatio = size.height / size.width
    }
    
    
}
