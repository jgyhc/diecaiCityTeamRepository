//
//  PKNetTool.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

let baseUrl = "http://picak.flyingeffect.com/info/"

class PKNetTool: NSObject {

    class func  requset(url:String, para:Parameters?, completionHandler: @escaping (JSON?, _ error:String?) -> Void) {
        
        let endPara = config(para: para)
        print(baseUrl + url)
        print(endPara)
        AF.request(baseUrl + url, method: .post, parameters: endPara).response { (responce) in
            
            if let err = responce.error {
                completionHandler(nil, err.localizedDescription)
                return
            }
            let json = JSON(responce.data!)
            if let a = json["code"].number, a == 1 {
                completionHandler(json["data"], nil)
            }else {
                completionHandler(nil, json["msg"].stringValue)
            }
        }
    }
    
    class func  down(url:URL, to:URL, progressHandler: @escaping (_ progress:Float) -> Void, completionHandler: @escaping (_ msg:String?) -> Void) {
        
        let destionation:DownloadRequest.Destination = {(url, response) in
            return (to, [.removePreviousFile,.createIntermediateDirectories])
        }
        
        let request:DownloadRequest = AF.download(url, interceptor: nil, to: destionation)
        request.downloadProgress { (progress) in
            progressHandler(Float(progress.completedUnitCount) / Float(progress.totalUnitCount))
        }
        request.response { (responce) in
            completionHandler(responce.error?.localizedDescription)
        }
    }
    
    
    class func config(para:Parameters?) -> Parameters {
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let time = String(Int(Date().timeIntervalSince1970))
        let imei = udid()
        
        var basePara:[String:Any] = ["platform" : "iOS",
                        "channel" : "iOS",
                        "version" : version ?? "",
                        "center_imei" : imei,
                        "imei" : imei,
                        "timestamp" : time
        ]
        
        if let p = para {
            basePara.merge(p) { (current, _) -> Any? in
                current //if has same key,return fist value
            }
        }

        let keys = basePara.keys.sorted()
        var paraString:String = ""
        
        
        for key:String in keys {
            let str:String = basePara[key] as! String
            paraString = paraString + key + "=" + str + "&"
        }

        paraString = paraString + "feishanpick@2021"
        let result = paraString.replacingOccurrences(of: " ", with: "")
        
        let nsStr:NSString = result as NSString
        let sign = nsStr.md5.lowercased()
        
        basePara["sign"] = sign
//        print(nsStr)
        return basePara as Parameters
    }
    
    class func udid() -> String {
        
        let keychain = Keychain(service: "com.udid_service.picak")
        if let udid = keychain["com.udid.picak"] {
            return udid
        }else {
            let udid = UIDevice.current.identifierForVendor?.uuidString
            keychain["com.udid.picak"] = udid
            return udid!
        }
    }
    
}
