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
        let liveModelArr: Driver<[livesModel]>
        let selectedPost: Driver<livesModel>
        let refreshStatus: Driver<refreshStatus>
    }
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        
        self.navigator = navigator
    }
    
    func transform( input: HomeViewModel.Input) -> HomeViewModel.Output {
        
        let liveModelArr = input.scale.flatMapLatest {[unowned self]  (scale) in
            return self.data(sale: scale).asDriverOnErrorJustComplete()
        }
        
        let selectedLivesModel  = input.selection.withLatestFrom(liveModelArr.scan([]){$1}) { (indexPath, livesModelArr) -> livesModel in
            return livesModelArr[indexPath.row]
        }
        let refreshStatus = Observable<refreshStatus>.create{ observable in
            
            _ =   liveModelArr
                .asObservable()
                .map{
                    
                    if  $0.count > 0{
                        observable.onNext(.dropDownSuccess)
                    }else{
                        observable.onNext(.invalidData)
                    }
                    
                }
                .subscribe(onNext: nil)
                .addDisposableTo(self.disposeBag)
            
            
            return Disposables.create()
            
        }
        
        return Output.init(liveModelArr: liveModelArr, selectedPost: selectedLivesModel, refreshStatus: refreshStatus.asDriverOnErrorJustComplete())
    }
    
    func data(sale:String) -> Observable<[livesModel]> {
        
        return BilibiliProvider.request(.getAppNewIndex_recommend(scale: "3"))
            .shareReplay(1)
            .filter{
                $0.statusCode == 200 ?true:false
            }
            .mapJSON()
            .map{
                
                homeRecommendModel.init(json: JSON.init($0)["data"]["recommend_data"]).lives!
        }
        
        
    }
    
    deinit {
        print("\(String.init(describing: type(of: self))) ---> 被销毁 ")
    }
}
