//
//  UIView+ORAdd.swift
//  Picak
//
//  Created by 欧阳荣 on 2021/4/20.
//

import UIKit
import Foundation
import Aspects

extension UIView {
    
    func or_addRoundedCorners(_ corners:UIRectCorner, _ raddif:Double) {
        
        self._or_addRoundedCorners(corners, raddif)
        
        let wrappedBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
            self._or_addRoundedCorners(corners, raddif)
        }
        let wrappedObject: AnyObject = unsafeBitCast(wrappedBlock, to: AnyObject.self)
        
        do {
            try self.aspect_hook(#selector(layoutSubviews), with: .positionAfter, usingBlock: wrappedObject)
        } catch {
            print(error)
        }
    }
    
    private func _or_addRoundedCorners(_ corners:UIRectCorner, _ raddif:Double) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: raddif, height: raddif))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        self.layer.mask = shape
    }
    
    
}
