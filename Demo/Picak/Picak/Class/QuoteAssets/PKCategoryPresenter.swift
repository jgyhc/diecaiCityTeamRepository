//
//  PKTypesPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/28.
//

import UIKit
import SwiftyJSON

protocol PKCategoriesPresenterDelegate:class {
    
    func update()
}

class PKCategoriesPresenter: NSObject {

    private (set) var ids:[String] = []
    private (set) var names:[String] = []
    
    weak var delegate:PKCategoriesPresenterDelegate!

    deinit {
        print("PKCategoriesPresenter deinit")
    }
    
    init(delegate:PKCategoriesPresenterDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func loadTypesData() {
        PKNetTool.requset(url: "template/categoryList", para: nil) { (data, aset) in
            
            if let dataArray = data {
                
                for item in dataArray.arrayValue {
                    
                    let id = item["id"].stringValue
                    let name = item["name"].stringValue
                    
                    self.names.append(name)
                    self.ids.append(id)
                    self.delegate.update()
                }
                
            }
            
        }
    }
    
}
