//
//  PKQuoteCustomPresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/27.
//

import UIKit

protocol PKQuoteCustomControllerProtocol:class {
    
    func changeDate(date:Date)
    func changeSource(source:String)
}

class PKQuoteCustomPresenter: NSObject {

    weak var controller:PKQuoteCustomControllerProtocol!

    func attach(controller c:PKQuoteCustomControllerProtocol) {
        self.controller = c
    }
}
