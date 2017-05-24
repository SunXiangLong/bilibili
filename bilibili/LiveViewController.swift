//
//  LiveViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/23.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

class LiveViewController: BaseViewController {
//    var model:homeModel?
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(10,10, 10, 10);
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10;
        layout.itemSize =  CGSize.init(width: (UIScreenWidth - 30)/2, height: (UIScreenWidth - 30)/2*180/320+40);
        collectionView.collectionViewLayout  = layout;
        bindViewModel()
    
    }
    var scale = 1
    func bindViewModel() {
      let just = Observable<String>.create {[unowned self]  observer in
        
        self.collectionView.mj_header = SXBilibiliNormalRefresh.init(refreshingBlock: {
             observer.on(.next(String.init(self.scale)))
        })
        
        return Disposables.create()
        }
        viewModel = HomeViewModel.init(navigator:UINavigationController.init())
        assert(viewModel != nil)
        let input = HomeViewModel.Input.init(scale: just.startWith("1").asDriverOnErrorJustComplete(), selection: collectionView.rx.itemSelected.asDriver())

        let output = viewModel.transform(input: input)
        
        output
            .liveModelArr
            .scan([])
            {  arr1,arr2 in
                return  arr2
            }
            .filter{
                if ($0.count>0){
                    return true
                }else{
                    return false
                }
                
            }
            .drive(collectionView.rx.items(cellIdentifier: "LiveCollectionViewCell", cellType: LiveCollectionViewCell.self)){ tv, item, cell in
               
                cell.model = item
                
            }.addDisposableTo(disposeBag)
        output.refreshStatus.drive(refreshStatusBinding).addDisposableTo(disposeBag)
        output.selectedPost.drive().addDisposableTo(disposeBag)
    
    
    }
    
    var refreshStatusBinding: UIBindingObserver<LiveViewController, refreshStatus> {
        return UIBindingObserver(UIElement: self, binding: {[unowned self]   (vc, refreshStatus) in
            self.collectionView.mj_header.endRefreshing()
         
            switch refreshStatus {
            case.dropDownSuccess:
                self.scale = self.scale + 1
             default: break
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
