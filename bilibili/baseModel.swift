//
//  baseModel.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/18.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import Foundation
import SwiftyJSON
protocol baseModel {
    
    var  code:Int{ get  set }
    var message:String{  get set  }
    var data:JSON{get  set }
    mutating  func  baseInit(json:JSON)
    
}

extension baseModel{
    mutating func baseInit(json:JSON){
        
        code = json["code"].intValue
        message = json["message"].stringValue
        data = json["data"]
    }

}
