//
//  PKTabBarController.swift
//  Picak
//
//  Created by OrangesAL on 2021/5/5.
//

import UIKit

class PKTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.delegate = self
    }
    
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = self.viewControllers?.firstIndex(of: viewController)
//        if index == 1 && PKUserService.shared.isLogin == false {
//            let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
//            loginVC?.modalPresentationStyle = .fullScreen
//            self.present(loginVC!, animated: true, completion: nil)
//            return false;
//        }
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
