//
//  CycleBanner.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/27.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher



class CirCleView: UIView {
    /*********************************** Property ****************************************/
    let time = TimeInterval.init(4)        //全局的时间间隔
    //MARK:- Property
    var contentScrollView: UIScrollView!
    var block:((bannerModel) -> Void)?
    var imageArray: [bannerModel]! {
        //监听图片数组的变化，如果有变化立即刷新轮转图中显示的图片
        willSet(newValue) {
            self.imageArray = newValue
        }
        /**
         *  如果数据源改变，则需要改变scrollView、分页指示器的数量
         */
        didSet {
            self.indexOfCurrentImage = 0
            setUpCircleView()
            self.setScrollViewOfImage()
            contentScrollView.isScrollEnabled = !(imageArray.count == 1)
            self.pageIndicator.frame = CGRect(x: self.frame.size.width - 20 * CGFloat(imageArray.count), y: self.frame.size.height - 30, width: 20 * CGFloat(imageArray.count), height: 20)
            self.pageIndicator?.numberOfPages = self.imageArray.count
            
        }
    }
    
    
    
    
    
    var indexOfCurrentImage: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            guard self.pageIndicator != nil  else {
                return
            }
            self.pageIndicator.currentPage = indexOfCurrentImage
        }
    }
    
    var currentImageView:   UIImageView!
    var lastImageView:      UIImageView!
    var nextImageView:      UIImageView!
    
    var pageIndicator:      UIPageControl!          //页数指示器
    
    var timer:              Timer?                //计时器
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    /*********************************** Begin ****************************************/
    //MARK:- Begin
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    convenience init(frame: CGRect, imageArray: [bannerModel]?) {
//        self.init(frame: frame)
//        self.imageArray = imageArray
//        // 默认显示第一张图片
//        self.indexOfCurrentImage = 0
//        self.setUpCircleView()
//    }
//    

    
    /********************************** Privite Methods ***************************************/
    //MARK:- Privite Methods
    fileprivate func setUpCircleView() {
        self.contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        contentScrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.isPagingEnabled = true
//        contentScrollView.backgroundColor = UIColor.green
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isScrollEnabled = !(imageArray.count == 1)
        self.addSubview(contentScrollView)
        
        self.currentImageView = UIImageView()
        currentImageView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height:  self.frame.size.height)
        currentImageView.isUserInteractionEnabled = true
//        currentImageView.contentMode = .scaleAspectFit
//        currentImageView.clipsToBounds = true
        contentScrollView.addSubview(currentImageView)
        
        //添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(CirCleView.imageTapAction(_:)))
        currentImageView.addGestureRecognizer(imageTap)
        
        self.lastImageView = UIImageView()
        lastImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        lastImageView.contentMode = .scaleAspectFit
//        lastImageView.clipsToBounds = true
        contentScrollView.addSubview(lastImageView)
        
        self.nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        nextImageView.contentMode = .scaleAspectFit
//        nextImageView.clipsToBounds = true
        contentScrollView.addSubview(nextImageView)
        
        self.setScrollViewOfImage()
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //设置分页指示器
        self.pageIndicator = UIPageControl(frame: CGRect(x: self.frame.size.width - 20 * CGFloat(imageArray.count), y: self.frame.size.height - 30, width: 20 * CGFloat(imageArray.count), height: 20))
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = imageArray.count
        pageIndicator.backgroundColor = UIColor.clear
        pageIndicator.pageIndicatorTintColor = UIColor.white
        pageIndicator.currentPageIndicatorTintColor = UIColor(red:249/255.0, green:116/255.0, blue:154/255.0, alpha: 1)
        self.addSubview(pageIndicator)
        
        //设置计时器
//        self.timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval:time, repeats: true, block: {[unowned self]  _ in
                self.timerAction()
                
            })
        }else{
            timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: 设置图片
    fileprivate func setScrollViewOfImage(){
        guard imageArray != nil else {
            return;
        }
        self.currentImageView.kf.setImage(with: self.imageArray[self.indexOfCurrentImage].img)
        self.nextImageView.kf.setImage(with: self.imageArray[self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)].img)
        self.lastImageView.kf.setImage(with: self.imageArray[self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)].img)
    }
    
    // 得到上一张图片的下标
    fileprivate func getLastImageIndex(indexOfCurrentImage index: Int) -> Int{
        let tempIndex = index - 1
        if tempIndex == -1 {
            return self.imageArray.count - 1
        }else{
            return tempIndex
        }
    }
    
    // 得到下一张图片的下标
    fileprivate func getNextImageIndex(indexOfCurrentImage index: Int) -> Int
    {
        let tempIndex = index + 1
        return tempIndex < self.imageArray.count ? tempIndex : 0
    }
    
    //事件触发方法
    func timerAction() {
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }
    
    
    /********************************** Public Methods  ***************************************/
    //MARK:- Public Methods
    func imageTapAction(_ tap: UITapGestureRecognizer){
        
        self.block!(self.imageArray[indexOfCurrentImage])
    }
    
    
    
    
}
/********************************** Delegate Methods ***************************************/
//MARK:- Delegate Methods
//MARK: UIScrollViewDelegate
extension CirCleView:UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //如果用户手动拖动到了一个整数页的位置就不会发生滑动了 所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //重置计时器
        if timer == nil {
            
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval:time, repeats: true, block: {[unowned self]  _ in
                    self.timerAction()
                    
                })
            }else{
                timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
            }
            //defaultRunLoopMode滚动视图的模式无效
            RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
            
        }
    }
    
    //时间触发器 设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
    
}
