//
//  BilibiliApi.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/18.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import Foundation
//
//  XiaoMaBaoAPI.swift
//  RXSwiftTest
//
//  Created by xiaomabao on 2017/4/24.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Result
import PKHUD
public let  HN = "Helvetica Neue";

/// 默认域名
let  api_live = "https://api.live.bilibili.com";
//let appendedParams: Dictionary<String, String> = [:]
/// 默认header
let headerFields: Dictionary<String, String> = [:]
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    
    
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        
        return data // fallback to original data if it can't be serialized.
    }
}
/// 一个闭包当XiaoMaBao存在的时候 添加header
let endpointClosure = { (target: Bilibili) -> Endpoint<Bilibili> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    return Endpoint<Bilibili>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        //        .adding(parameters: appendedParams as [String : AnyObject])
        .adding(newHTTPHeaderFields: headerFields)
}
let  BilibiliProvider =  RxMoyaProvider<Bilibili>(/*endpointClosure: endpointClosure,*/plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)/*,RequestAlertPlugin()*/])
//let XiaoMabaoProviderNoHUD =  RxMoyaProvider<Bilibili>(endpointClosure: endpointClosure,plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
public enum Bilibili {
    case getAppNewIndex_recommend(scale:String)
    case getAppNewIndex_common(scale:String)
    case getAppNewIndex_recommendRefresh
    case getAppIndex_dynamic(area:String)
    
}
/// 自定义插件实现请求添加HUD
final class RequestAlertPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        //实现发送请求前需要做的事情
        HUD.dimsBackground = false;
        HUD.show(.success)
    }
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        HUD.hide()
        guard case Result.failure(_) = result else { return }//只监听失败
        HUD.flash(.error, delay: 1)
    }
}

// MARK: - 请求的参数
extension Bilibili:TargetType{
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: api_live)!
        }
    }
    public var path: String {
        switch self {
        case .getAppNewIndex_recommend(_):
            return "/AppNewIndex/recommend"
        case .getAppNewIndex_common(_):
            return "/AppNewIndex/common"
        case .getAppNewIndex_recommendRefresh:
            return "/AppIndex/recommendRefresh"
        case .getAppIndex_dynamic(_):
            return "/AppIndex/dynamic"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .getAppNewIndex_recommend(let scale):
            return ["scale":scale,
                    "actionKey": "appkey",
                    "appkey": "27eb53fc9058f8c3",
                    "build":"5800",
                    "buvid":"aa4ee2ed6d2ec78089a21c86093a298b",
                    //                    "channel":"appstore",
                    "device":"phone",
                    "mobi_app":"iphone",
                    "platform":"ios",
                    "sign":"512605b1692396bfcaad0cc8f3076dc7",
//                "ts": "1498801813"//Int(Date().timeIntervalSince1970)
            ]
            
        case .getAppNewIndex_common(let scale):
            return ["scale":scale,
                    "device":"phone",
                    "platform":"ios",
            ]
            
        case .getAppNewIndex_recommendRefresh:
            return ["actionKey": "appkey",
                    "appkey": "27eb53fc9058f8c3",
                    "build":"5800",
                    "device":"phone",
                    "mobi_app":"iphone",
                    "platform":"ios",
                    "sign":"a3b2835248fd568f4f977f05dc97e539",
                    "ts": "1498817320"//Int(Date().timeIntervalSince1970)
            ]
        case .getAppIndex_dynamic(let area):
            return [
                    "area":"draw",//签名方式未知，只能固定这个
                    "actionKey": "appkey",
                    "appkey": "27eb53fc9058f8c3",
                    "build":"5800",
                    "device":"phone",
                    "mobi_app":"iphone",
                    "platform":"ios",
                    "sign":"6bfbe21428a38c0baa07fd77c4baf066",
                    "ts": "1498817479"//Int(Date().timeIntervalSince1970)
            ]
            
        }
    }
    public var task: Task {
        return .request
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var validate: Bool {
        
        switch self {
        default:
            return true
        }
    }
    public var sampleData: Data {
        return "请检查你的网络连接和联系客服".data(using: String.Encoding.utf8)!
        //        switch self {
        //        case .getCategoryGoods(_, _):
        //
        //        case .getCategoryGoodsTest(_, _):
        //            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        //        }
    }
    
}

// MARK: - 字符串转url字符串
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
