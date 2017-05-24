//
//  UIImage+color.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/24.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
extension UIImage {

    func imageWithTintColor(tintColor:UIColor, blendMode:CGBlendMode) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        tintColor.setFill()
        
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != .destinationIn {
            
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
            
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return tintedImage!
        
    }
}
