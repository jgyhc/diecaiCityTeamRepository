//
//  PKMusicListPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/5/10.
//

import UIKit
import SwiftyJSON


protocol PKMusicListControllerProtocol:class {
    func update()
    func loadFailure()
    func endRefreshWithNoMoreData()
}

class PKMusicListPresenter: NSObject {
    
    weak var controller:PKMusicListControllerProtocol!
    private (set) var data:[JSON] = []
    private (set) var page = 1
    private (set) var isLoading = false
    
    func attach(controller:PKMusicListControllerProtocol) {
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
        
        let para = ["page" : String(page)]
        isLoading = true
        PKNetTool.requset(url: "template/musicList", para: para) {(data, error) in
            
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
