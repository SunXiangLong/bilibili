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
import RxDataSources
import GDPerformanceView_Swift
class LiveViewController: BaseViewController {
    
    var viewModel: HomeViewModel!
    var dataSource : RxCollectionViewSectionedReloadDataSource<sectionsModel>?
    let top = UIScreenWidth*5/16 + UIScreenWidth*7/31;
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var shufflingView: CirCleView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        topView.frame = CGRect.init(x: 0, y: -top, width: UIScreenWidth, height: top)
        collectionView.contentInset = UIEdgeInsets.init(top: top, left: 0, bottom: 0, right: 0);
        shufflingView.block = {
            
            log.debug($0)
        }
        collectionView.addSubview(topView);
        GDPerformanceMonitor.sharedInstance.startMonitoring()
        
    }
    var obser:AnyObserver<dataType>?
    func bindViewModel() {
        
        let just = Observable<dataType>.create {[unowned self]  observer in
            self.obser = observer
            self.collectionView.mj_header = SXBilibiliNormalRefresh.init(refreshingBlock: {
                observer.on(.next(.initializeTheData))
            })
            self.collectionView.mj_header.ignoredScrollViewContentInsetTop = self.top;
            return Disposables.create()
        }
        
        viewModel = HomeViewModel.init(navigator:UINavigationController.init())
        assert(viewModel != nil)
        
        let input = HomeViewModel.Input.init(scale: just.startWith(.initializeTheData).asDriver(onErrorJustReturn: .initializeTheData), selection: collectionView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        dataSource = RxCollectionViewSectionedReloadDataSource<sectionsModel>()
        
        collectionViewSectionedReloadDataSource(dataSource!)
        
        output
            .homeModel
            .map{
                self.shufflingView.imageArray = $0.common_data?.banner;
                if $0.sections.count > 0{
                    self.topView.isHidden = false;
                }
                return  $0.sections
            }
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource!))
            .addDisposableTo(disposeBag)
        
        collectionView.rx.setDelegate(self).addDisposableTo(disposeBag)
        output.refreshStatus.drive(refreshStatusBinding).addDisposableTo(disposeBag)
        
        
        
    }
    
    func collectionViewSectionedReloadDataSource(_ dataSource: RxCollectionViewSectionedReloadDataSource<sectionsModel>) {
        
        dataSource.configureCell  = { (dataSource, collectionView, indexPath, _) in
            let cell: LiveCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
            if indexPath.section == 0 {
                cell.isAreaHidden = true
            }else{
                cell.isAreaHidden = false
            }
            let arr = dataSource[indexPath.section].rows
            if indexPath.item == arr.count - 1 {
                cell.isRefresh = true
                
            }else{
                cell.isRefresh = false
                
            }
            cell.section = indexPath.section
            cell.model =  dataSource[indexPath.section].items[indexPath.item]
            cell.refreshBlock = { (isRefresh,section) in
                
                if isRefresh{
                   self.obser?.onNext(.refreshZeroSectionsData)
                    
                }else{
                    self.obser?.onNext(.refreshData(area: dataSource[section].headerModel.area,section: section))
                    
                }
                
            }
            return cell
            
        }
        
        dataSource.supplementaryViewFactory = {(dataSource, collectionView, kind, indexPath) in
            
            switch kind {
            case UICollectionElementKindSectionHeader:
                let rusableViewHeadView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "colllectionViewHeadView", for: indexPath) as! liveReusableHeaderView
                rusableViewHeadView.model = dataSource[indexPath.section].headerModel
                
                rusableViewHeadView.moreLive = {[unowned self]   model in
                    
                    log.debug(model)
                }
                
                return rusableViewHeadView
            default:
                let rusableViewFootView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "colllectionViewFootView", for: indexPath)
                
                return rusableViewFootView
            }
            
        }
        
    }
    //     // MARK: StoryBoard界面跳转传参数
    //    var selectedBinding: UIBindingObserver<LiveViewController, livesModel> {
    //        return UIBindingObserver(UIElement: self, binding: {[unowned self]   (vc, model) in
    //
    //        })
    //    }
    var refreshStatusBinding: UIBindingObserver<LiveViewController, refreshStatus> {
        return UIBindingObserver(UIElement: self, binding: {[unowned self]   (vc, refreshStatus) in
            self.collectionView.mj_header.endRefreshing()
            
            switch refreshStatus {
            case.dropDownSuccess:
                log.info("1111"); break
            default: break
            }
        })
    }
    // MARK: StoryBoard界面跳转传参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! LiveRoomViewController
        vc.model = sender as? livesModel
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
// MARK: UICollectionViewDelegate
extension LiveViewController:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.debug(indexPath.item)
        let model = dataSource![indexPath.section]
        self.performSegue(withIdentifier: "LiveRoomViewController", sender: model.items[indexPath.item])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsetsMake(10,10, 10,10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource?[indexPath.section]
        
        if indexPath.section == 0 {
            if Int(Double((model!.rows.count - 1)) * 0.5) == indexPath.row{
                
                return CGSize.init(width: UIScreenWidth - 20, height: (UIScreenWidth - 30)*0.5*18/32 + 40)
            }
            
        }
        return CGSize.init(width: (UIScreenWidth - 30)*0.5, height: (UIScreenWidth - 30)*0.5*18/32 + 40)
    }
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        guard let _ = dataSource?[section]else {
            return CGSize.init(width: 0, height: 0 )
        }
        
        return CGSize.init(width: UIScreenWidth, height: 35 )
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        
        if section == 9 {
            return CGSize.init(width: UIScreenWidth, height: 54 )
        }
        
        return CGSize.init(width: 0, height: 0 )
    }
    
    
    
}


