//
//  PKUserService.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/6.
//

/*
 
 "gender" : 0,
 "password" : "",
 "id" : 5,
 "joinip" : "",
 "logintime" : "2021-05-06 15:51:09",
 "username" : "",
 "money" : "0.00",
 "channel" : "iOS",
 "nickname" : "",
 "verification" : "",
 "jointime" : null,
 "unionid" : "apple_000461.a2e3dee3201e4cdebf8e068efbbd400e.0344",
 "loginfailure" : 0,
 "loginip" : "",
 "bio" : "",
 "successions" : 1,
 "score" : 0,
 "platform" : "iOS",
 "level" : 0,
 "birthday" : null,
 "now_version" : "1.0",
 "maxsuccessions" : 1,
 "center_imei" : "671F22AC-D2A3-4E80-A06A-D7BF9920B5D1",
 "createtime" : "2021-05-06 15:51:09",
 "mobile" : "",
 "status" : "",
 "avatar" : "",
 "regiter_version" : "1.0",
 "imei" : "671F22AC-D2A3-4E80-A06A-D7BF9920B5D1",
 "salt" : "",
 "token" : "1620287469xZnlzv4IXQuFET16R0DyBb",
 "prevtime" : "2021-05-06 15:51:09",
 "group_id" : 0,
 "email" : "",
 "type" : 1,
 "updatetime" : "2021-05-06 15:51:09"
 
 */


import UIKit
import SwiftyJSON
import Cache

let LoginChangedNotificationName = NSNotification.Name("LoginChangedNotificationName")

class PKUserService {
    static let shared = PKUserService()
    
    var cache:Storage<String, JSON>!
    
    private var _userInfo:JSON?
    
    var userInfo:JSON? {
        set {
            _userInfo = newValue
            self.updateCahce()
            NotificationCenter.default.post(name: LoginChangedNotificationName, object: nil, userInfo: nil)
        }
        get {
            return _userInfo
        }
    }
    

    var token:String? {
        return _userInfo?["token"].stringValue
    }
    var userID:String? {
        return _userInfo?["id"].stringValue
    }
    var avatar:URL? {
        return _userInfo?["avatar"].url
    }
    var nickname:String? {
        return _userInfo?["nickname"].stringValue
    }
    
    var isLogin:Bool {
        return _userInfo != nil && (_userInfo?["token"].stringValue)!.count > 0
    }
    
    private init() {
        
        let diskConfig = DiskConfig(name: "com.picak")
        let memoryConfig = MemoryConfig()

        self.cache = try? Storage<String, JSON>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: JSON.self) // Storage<String, User>
        )
        
        _userInfo = try? self.cache.object(forKey: "com.picak.user")
    }
    
    
    func updateCahce() {
        
        if let info = _userInfo {
            let queue = DispatchQueue(label: "com.picak.storeUser")
            queue.async {
                try? self.cache.setObject(info, forKey: "com.picak.user")
            }
        }
    }
    
}
