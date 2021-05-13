//
//  PKLoginPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/6.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

protocol PKLoginPresneterProtocol:class {
    func loginSuccess()
    func startLogin()
    func loginFail(msg:String?)
}

class PKLoginPresenter: NSObject {

    lazy var appleService:FEAppleLoginService! = FEAppleLoginService()
    lazy var faceBookService:LoginManager! = LoginManager.init()

    weak var controller:PKLoginPresneterProtocol!
    
    init(controller:PKLoginPresneterProtocol) {
        super.init()
        self.controller = controller
    }
    
    deinit {
        print("PKLoginPresenter deinit")
    }
    
    func appleLogin() {
        
        self.appleService.fe_appleRequest { [weak self](userId, authCode, identifytoken) in
            self?.controller.startLogin()
            
            let param = ["type":"1",
                         "identifytoken" : identifytoken]
            PKNetTool.requset(url: "user/login", para: param) { (data, errorMsg) in
                
                if let msg = errorMsg {
                    self?.controller.loginFail(msg:msg)
                } else {
                    PKUserService.shared.userInfo = data
                    self?.controller.loginSuccess()
                }
            }
        } error: { [weak self](error) in
            self?.controller.loginFail(msg: error.localizedDescription)
        }
    }
    
    func facebookLogin() {
        
        let controller:UIViewController = self.controller as! UIViewController
        
        self.faceBookService.logIn(permissions: ["public_profile"], from: controller) { [weak self](result, error) in
            if let err = error {
                self?.controller.loginFail(msg: err.localizedDescription)
                return
            }
            
            if result?.isCancelled == true {
                self?.controller.loginFail(msg: "cancelled")
                return
            }
            
            let param = ["fields":"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"]
            
            let request = GraphRequest(graphPath: result!.token!.userID, parameters: param, httpMethod: HTTPMethod(rawValue: "GET"))
            
            request.start { (connection, result, error1) in
                if let err = error1 {
                    self?.controller.loginFail(msg: err.localizedDescription)
                    return
                }
                
                let json = JSON(result!)
                
                let param = ["type":"2",
                             "unionid" : json["id"].stringValue,
                             "nickname" : json["name"].stringValue,
                             "avatar" : json["picture"]["data"]["url"].stringValue]
                PKNetTool.requset(url: "user/login", para: param) { (data, errorMsg) in
                    
                    if let msg = errorMsg {
                        self?.controller.loginFail(msg:msg)
                    } else {
                        PKUserService.shared.userInfo = data
                        self?.controller.loginSuccess()
                    }
                }
                
            }
            
        }
    }
    
}
