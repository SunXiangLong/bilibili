//
//  HomeModel.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/18.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import Foundation
import SwiftyJSON
struct homeModel{
    var recommend_data:homeRecommendModel?
    var  Common_data:homeRecommendModel?
}
struct homeRecommendModel {
    let lives: Array<livesModel>?
    let partition:partitionModel?
    let banner_data:Array<livesModel>?
    init(json:JSON) {
        lives = json["lives"].arrayValue.map{
            livesModel.init(json: $0)
        }
        banner_data = json["banner_data"].arrayValue.map{
            livesModel.init(json: $0)
        }
        partition =  partitionModel.init(fromJson: json["partition"]);
    }
}
struct livesModel {
    let owner:ownerModel?
    let cover:coverModel?
    let room_id:Int?
    let check_version:Int?
    let online:Int?
    let area:String?
    let area_id:Int?
    let title:String?
    let playurl:URL?
    let accept_quality:String?
    let broadcast_type:Int?
    let is_tv:Bool?
    
    init(json:JSON) {
        accept_quality = json["accept_quality"].stringValue
        area = json["area"].stringValue
        area_id = json["area_id"].intValue
        broadcast_type = json["broadcast_type"].intValue
        check_version = json["check_version"].intValue
        cover = coverModel(fromJson: json["cover"])
        is_tv = json["is_tv"].boolValue
        online = json["online"].intValue
        owner = ownerModel(fromJson: json["owner"]);
        playurl = json["playurl"].url
        room_id = json["room_id"].intValue
        title = json["title"].stringValue
    }
  
    
    
}
struct ownerModel {
    let face:URL?
    let mid:Int?
    let name:String?
   
    
    init(fromJson json:JSON) {
        face = json["face"].url
        mid = json["mid"].intValue
        name = json["name"].stringValue
    }
   
}
struct coverModel {
    let src:URL?
    let height:Float?
    let width:Float?
    
    init(fromJson json:JSON) {
        src = json["src"].url
        height = json["height"].floatValue
        width = json["width"].floatValue
    }
}

struct partitionModel {
    typealias SubIcon = coverModel
    let area : String!
    let count : Int!
    let id : Int!
    let name : String!
    let subIcon : SubIcon!
    init(fromJson json:JSON) {
        area = json["area"].stringValue
        count = json["count"].intValue
        id = json["id"].intValue
        name = json["name"].stringValue
        subIcon  = coverModel.init(fromJson: json["sub_icon"])
    }
}


struct homeCommonModel {
    let banner:Array<bannerModel>?
    let entranceIcons:Array<entranceIconsModel>?
    let partitions:Array<partitionsModel>?
    let navigator:Array<entranceIconsModel>?
    init(json:JSON) {
        banner = json["banner"].arrayValue.map{
            bannerModel.init(json: $0)
        }
        entranceIcons = json["entranceIcons"].arrayValue.map{
            entranceIconsModel.init(json: $0)
        }
        partitions = json["partitions"].arrayValue.map{
            partitionsModel.init(json: $0)
        }
        navigator = json["navigator"].arrayValue.map{
            entranceIconsModel.init(json: $0)
        }
    }
}
struct bannerModel {
    let img:URL?
    let remark:String?
    let link:URL?
    let title:String?
    
    init(json:JSON) {
        img = json["img"].url
        link = json["link"].url
        remark = json["remark"].stringValue
        title = json["title"].stringValue
    }
}

struct entranceIconsModel {
    typealias entranceIcon = coverModel
    let id:Int?
    let name:String?
    let entrance_icon:entranceIcon?
    init(json:JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        entrance_icon = coverModel.init(fromJson: json["entrance_icon"])
    }
}

struct partitionsModel {
    let partition:partitionModel?
    let lives: Array<livesModel>?
    init(json:JSON) {
        lives = json["lives"].arrayValue.map{
            livesModel.init(json: $0)
        }
        partition =  partitionModel.init(fromJson: json["partition"]);
    }
}



