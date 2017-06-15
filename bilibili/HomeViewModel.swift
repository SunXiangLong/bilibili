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

final class HomeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    struct Input {
        let scale:Driver<String>
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
        
        let homeModel = input.scale.flatMapFirst{
            return self.data(sale: $0).asDriverOnErrorJustComplete()
        }
        
        let refreshStatus = Observable<refreshStatus>.create{ observable in
            
            _ =   homeModel
                .asObservable()
                .map{
                    
                    if  ($0.common_data?.partitions.count)! > 0{
                        observable.onNext(.dropDownSuccess)
                    }else{
                        observable.onNext(.invalidData)
                    }
                    
                }
                .subscribe(onNext: nil)
                .addDisposableTo(self.disposeBag)
            
            
            return Disposables.create()
            
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
                $0["code"].boolValue ? false:true
            }
            .map{
                
                homeCommonModel.init(json: $0["data"])
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
                $0["code"].boolValue ? false:true
            }
            .map{
                homeRecommendModel.init(json: $0["data"]["recommend_data"])
        }
        
        
    }
    
    deinit {
        print("\(String.init(describing: type(of: self))) ---> 被销毁 ")
    }
}
