//
//  PKAPPService.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/6.
//

import UIKit
import Kingfisher
import KingfisherWebP

let DOCUMENTPATH:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!

let PK_TEMP_PATH = DOCUMENTPATH + "/PK_TEMP_PATH"

let PK_DOWNLOAD_PATH = DOCUMENTPATH + "/PK_DOWNLOAD_PATH"

class PKAPPService {

    class func appConfig() {
        
        KingfisherManager.shared.defaultOptions += [
          .processor(WebPProcessor.default),
          .cacheSerializer(WebPSerializer.default)
        ]
        
        FileManager.nt_deletFile(atPath: PK_TEMP_PATH)
        FileManager.nt_creatDirectory(atPath: PK_TEMP_PATH)
    }
    
}
