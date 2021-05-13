//
//  PKAssetPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/28.
//

import UIKit
import SwiftyJSON

protocol PKAssetControllerProtocol:class {
    func update()
    func loadFailure()
    func endRefreshWithNoMoreData()
}

class PKAssetPresenter: NSObject {
    
    weak var controller:PKAssetControllerProtocol!
    private (set) var data:[JSON] = []
    private (set) var id:String!
    private (set) var page = 1
    private (set) var isLoading = false

    init(id:String) {
        super.init()
        self.id = id
    }
    
    func attach(controller:PKAssetControllerProtocol) {
        self.controller = controller
    }
    
    func refresh() {
        if isLoading == true {
            return
        }
        page = 1
        loadData()
    }
    
    func loadMore() {
        if isLoading == true {
            return
        }
        page += 1
        loadData()
    }
    
    private func loadData() {
        
        let para = ["page" : String(page),
                    "category_id" : id!] as [String : Any]
        isLoading = true
        PKNetTool.requset(url: "template/templateList", para: para) {(data, error) in
            
            self.isLoading = false
            
            if let d = data {
                if self.page == 1 {
                    self.data.removeAll()
                }
                self.data.append(contentsOf: d.arrayValue)
            }
            
            self.controller.update()
        }
    }
}
