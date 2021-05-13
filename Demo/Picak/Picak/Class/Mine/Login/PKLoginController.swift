//
//  PKLoginController.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/20.
//

import UIKit
import YYText
import SnapKit
import SVProgressHUD

class PKLoginController: UIViewController {

    let protocolLabel = YYLabel()
    var presenter:PKLoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        presenter = PKLoginPresenter(controller: self)
        
        protocolLabel.font = UIFont.systemFont(ofSize: 11)
        
        let text:NSString = "Log in means you agree to the User Agreement and Privacy Policy"
        
        
        let attr = NSMutableAttributedString(string: "Log in means you agree to the User Agreement and Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor : UIColor.nt_color(withHexString: "#C8C8C8")!])
        
        let agreementRange = text.range(of: "User Agreement")
        let policyRange = text.range(of: "Privacy Policy")

        attr.yy_setTextHighlight(agreementRange, color: UIColor.blue, backgroundColor: nil) { [weak self](containerView, attr, range, rect) in
            let vc = FEWebViewController.fe_webNavgationController(withTitle: attr.string, webUrl: "http://picak.flyingeffect.com/picak/agree.html")
            self?.present(vc, animated: true, completion: nil)
        }
        
        attr.yy_setTextHighlight(policyRange, color: UIColor.blue, backgroundColor: nil) { [weak self](containerView, attr, range, rect) in
            let vc = FEWebViewController.fe_webNavgationController(withTitle: attr.string, webUrl: "http://picak.flyingeffect.com/picak/privac.html")
            self?.present(vc, animated: true, completion: nil)
        }
        
        protocolLabel.attributedText = attr;
        self.view.addSubview(protocolLabel)
        
        protocolLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
    }
    

    // MARK: - action
    @IBAction func action_close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func action_faceBook(_ sender: Any) {
        presenter.facebookLogin()
    }
    @IBAction func action_apple(_ sender: Any) {
        presenter.appleLogin()
    }

}

extension PKLoginController:PKLoginPresneterProtocol {
    func loginSuccess() {
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    func startLogin() {
        SVProgressHUD.show()
    }
    
    func loginFail(msg: String?) {
        SVProgressHUD.showError(withStatus: msg)
    }
}
