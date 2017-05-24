//
//  SXBilibiliNormalRefresh.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/23.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit
let blackColor = UIColor.black
let logoImageViewTop = 6
class SXBilibiliNormalRefresh: MJRefreshHeader {
    lazy var logoImageView:UIImageView = {
        let  logoImageView = UIImageView.init(image: #imageLiteral(resourceName: "refresh_logo_1"))
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    lazy var titleLabel:UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.textColor = blackColor
        titleLabel.font = UIFont.init(name: HN, size: 14)
        titleLabel.textAlignment = .center
        titleLabel.text = "再拉，再拉就刷给你看"
        titleLabel.isHidden = false
        titleLabel.sizeToFit()
        return titleLabel
    }()
    lazy var arrowImageView:UIImageView = {
        let  arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: "arrow"))
        arrowImageView.contentMode = .scaleAspectFit
        return arrowImageView
    }()
    lazy var loading:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        return loading
    }()
    lazy var animateImages:Array<UIImage> = {
        return [#imageLiteral(resourceName: "refresh_logo_1"),#imageLiteral(resourceName: "refresh_logo_2"),#imageLiteral(resourceName: "refresh_logo_3"),#imageLiteral(resourceName: "refresh_logo_4")]
    }()
 
    
//    init!(refreshingBlock: MJRefresh.MJRefreshComponentRefreshingBlock!){
//    
//    }
//    
  
    override func prepare() {
        super.prepare()
        self.mj_h = 88
        //标签
        self.addSubview(self.logoImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.arrowImageView)
        self.addSubview(loading)
        
    }
    override func placeSubviews() {
        super.placeSubviews()
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.mj_w * 0.5)
            $0.top.equalTo(logoImageViewTop)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(-2)
            $0.right.equalTo(logoImageView.snp.left).offset(14)
            
        }
        
        loading.snp.makeConstraints{
            $0.center.equalTo(arrowImageView)
        }
        
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(arrowImageView.snp.right).offset(2)
            $0.top.equalTo(logoImageView.snp.bottom).offset(6)
        }
        
    }
    //MARK: 监听scrollView的contentOffset改变
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        if self.state == .idle {
            let offset = change["new"] as! CGPoint
            if offset.x == 0 {
                titleLabel.text = "再拉，再拉就刷给你看"
                titleLabel.sizeToFit()
            }
        }
    }
    //MARK: 监听scrollView的contentSize改变
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    //MARK:监听scrollView的拖拽状态改变
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    
    
    //MARK: 监听控件的刷新状态
    override var state: MJRefreshState{
        didSet{
            switch state {
            case .idle:
                switch oldValue {
                case .refreshing:
                    arrowImageView.transform = .identity
                    titleLabel.text = "刷呀刷呀，刷完啦，喵^ω^"
                    titleLabel.sizeToFit()
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.loading.alpha = 0.0
                        
                    }, completion: {  finished in
                        guard self.state != .idle else {return}
                        self.loading.alpha = 1.0
                        self.loading.stopAnimating()
                        self.arrowImageView.isHidden = false
                    })
                default:
                    titleLabel.text = "再拉，再拉就刷给你看"
                    titleLabel.sizeToFit()
                    loading.stopAnimating()
                    arrowImageView.isHidden = false
                    UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                        self.loading.alpha = 0.0
                        self.arrowImageView.transform = .identity
                    })
                }
            case .pulling:
                loading.stopAnimating()
                arrowImageView.isHidden = false
                titleLabel.text = "够了啦，松开人家嘛";
                titleLabel.sizeToFit()
                UIView.animate(withDuration: TimeInterval(MJRefreshSlowAnimationDuration), animations: {
                
                    self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: .pi)
                })
                
            case .refreshing:
                loading.alpha = 1.0// 防止refreshing -> idle的动画完毕动作没有被执行
                loading.stopAnimating()
                arrowImageView.isHidden = true
                logoImageView.animationImages = self.animateImages
                logoImageView.startAnimating()
                titleLabel.text = "刷呀刷呀，好累啊，喵^ω^"
                titleLabel.sizeToFit()

            default:break
            }
        }
    }
    //MARK  监听拖拽比例（控件被拖出来的比例）
    
    override var pullingPercent: CGFloat{
        didSet{
        
            super.pullingPercent = pullingPercent;
        }
    }
}

