//
//  PKHomePresenter.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/16.
//

import Foundation

struct PKHomeModule {
    var type:PKHomeModuleType!
    var imageName:String!
}

enum PKHomeModuleType:Int {
    case excerpt
    case quotes
}
