//
//  HomeViewModel.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/18.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
protocol PostsNavigator {
    func toPost(_ model: livesModel)
}

enum refreshStatus: Int {
    case dropDownSuccess // 下拉成功
    case pullSuccessHasMoreData // 上拉，还有更多数据
    case pullSuccessNoMoreData // 上拉，没有更多数据
    case invalidData // 无效的数据，请求失败或返回空数据等
}
enum dataType {
    case initializeTheData // 初始化数据和下拉刷新数据
    case refreshZeroSectionsData // 刷新第一个section数据
    case refreshData(area:String,section:Int) // 刷新其他section数据
}
final class HomeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    
    
    struct Input {
        let scale:Driver<dataType>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let homeModel: Driver<homeModel>
        //        let selectedPost: Driver<livesModel>
        let refreshStatus: Driver<refreshStatus>
    }
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        
        self.navigator = navigator
    }
    func selected(model:livesModel) {
        print(model)
    }
    func transform( input: HomeViewModel.Input) -> HomeViewModel.Output {
        
        var obser:AnyObserver<refreshStatus>?
        var oldModel:homeModel?
        let refreshStatus = Observable<refreshStatus>.create{ observable in
            
            obser = observable
            
            
            return Disposables.create()
            
        }
        
        let homeModel = input.scale.flatMapFirst{[unowned self]  type -> SharedSequence<DriverSharingStrategy, homeModel> in
            

            switch type {
            case .initializeTheData:
                return self.data(sale: "3")
                    .filter({ model -> Bool in
                        oldModel = model
                        
                        if model.sections.count > 0{
                            obser?.onNext(.dropDownSuccess)
                        }else{
                            obser?.onNext(.invalidData)
                        }
                        return true
                        
                    }).asDriverOnErrorJustComplete()
            case .refreshZeroSectionsData:
                return self.recommendRefresh().map{ homeRModel in
                    var rows =  [] + homeRModel.lives;
                    rows.insert(homeRModel.banner_data.first!, at: Int(Double( homeRModel.lives.count) * 0.5))
                    oldModel!.sections[0] = sectionsModel.init(headerModel: homeRModel.partition, rows: rows)
                    return oldModel!
                    }.asDriverOnErrorJustComplete()
                
                
                
            case .refreshData(let area, let section ):
                return self.recommendDynamic(area: area).map{ arr in
                    let model = oldModel!.sections[section];
                    
                    oldModel!.sections[section] = sectionsModel.init(original: model, items: arr)
                    return oldModel!
                    }.asDriverOnErrorJustComplete()
            }
            
        }
        
        return Output.init(homeModel: homeModel,  refreshStatus: refreshStatus.asDriverOnErrorJustComplete())
        
    }
    func data(sale:String) -> Observable<homeModel> {
        return Observable.combineLatest(common(sale: sale),recommend(sale: sale)) {
            
            return  homeModel.init(recommend_data: $1, common_data:$0)
        }
    }
    
    func common(sale:String) -> Observable<homeCommonModel> {
        return BilibiliProvider.request(.getAppNewIndex_common(scale:sale ))
            .shareReplay(1)
            .filter{
                $0.statusCode == 200 ?true:false
            }
            .mapJSON()
            .map{
                JSON.init($0)
            }
            .filter{
                $0["code"].boolValue ?false:true
            }
            .map{
                
                homeCommonModel.init(json: $0["data"])
        }
    }
    
    func recommendRefresh()  -> Observable<homeRecommendModel>{
        
        return BilibiliProvider.request(.getAppNewIndex_recommendRefresh)
            .shareReplay(1)
            .filter{
                $0.statusCode == 200 ?true:false
            }
            .mapJSON()
            .map{
                JSON.init($0)
            }
            .debug()
            .filter{
                $0["code"].boolValue ?false:true
            }
            .map{
                homeRecommendModel.init(json: $0["data"])
        }
        
    }
    func recommendDynamic(area:String)  -> Observable<[livesModel]>{
        
        return BilibiliProvider.request(.getAppIndex_dynamic(area: area))
            .shareReplay(1)
            .debug()
            .filter{
                $0.statusCode == 200 ?true:false
            }
            .mapJSON()
            .map{
                JSON.init($0)
            }
            .debug()
            .filter{
                $0["code"].boolValue ?false:true
            }
            
            .map{
                $0["data"].arrayValue.map{
                    livesModel.init(json: $0)
                    }.randomNumber(num: 4)
                
        }
        
    }
    func recommend(sale:String) -> Observable<homeRecommendModel> {
        
        return BilibiliProvider.request(.getAppNewIndex_recommend(scale: sale))
            .shareReplay(1)
            .filter{
                $0.statusCode == 200 ?true:false
            }
            .mapJSON()
            .map{
                JSON.init($0)
            }
            .filter{
                $0["code"].boolValue ?false:true
            }
            .map{
                homeRecommendModel.init(json: $0["data"]["recommend_data"])
        }
        
        
    }
    
    deinit {
        print("\(String.init(describing: type(of: self))) ---> 被销毁 ")
    }
}
