//
//  LiveRoomViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/24.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import Foundation
import IJKMediaFramework
class LiveRoomViewController: BaseViewController,UINavigationControllerDelegate,Autorotate {

    var player:IJKMediaPlayback?
    
    
    // true为横屏进行横屏相关操作 false为竖屏进行竖屏操作
    var isLandscapeLeft:Bool?{
        didSet{
            if isLandscapeLeft! {
                landscapeLeft()
            }else{
                portrait()
            }
        
        }
    }
    var model:livesModel?{
        
        didSet{
            
            IJKFFMoviePlayerController.setLogReport(true)
            IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_VERBOSE)
            IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
            let options =  IJKFFOptions.byDefault()
            player = IJKFFMoviePlayerController.init(contentURL:model?.playurl, with: options)
            player?.view.frame = CGRect.init(x: 0, y: 0, width: UIScreenHeight, height: UIScreenWidth)
            player?.scalingMode = .none
            player?.shouldAutoplay = true
            player?.setPauseInBackground(true)
            self.view.addSubview((self.player?.view)!)
//            log.info(player.bufferingProgress
            player?.view.backgroundColor = UIColor.white
        }
    }


    override var shouldAutorotate: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        installMovieNotificationObservers()
        player?.prepareToPlay()
        self.navigationController?.delegate = self;
    }
    override func viewWillDisappear(_ animated: Bool) {
        isLandscapeLeft = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player?.stop()

        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isLandscapeLeft = true
//        UIApplication.shared.setStatusBarHidden(false, with: .fade)
//        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationController?.setNavigationBarHidden(viewController.isKind(of: self.classForCoder), animated: true)
    }
    func installMovieNotificationObservers()  {
        NotificationCenter.default.rx.notification(NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: nil).subscribe { (noti) in
            let player = noti.element?.object as! IJKFFMoviePlayerController
            if player.loadState == .stalled{
                log.info("缓冲开始")
                
            }else if (player.loadState == .playable || player.loadState == .playthroughOK){
                log.info("缓冲结束")
            }}.addDisposableTo(disposeBag)
        NotificationCenter.default.rx.notification(NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player).subscribe { (noti) in
            
            log.info("1111")
            
            }.addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.IJKMPMoviePlayerFirstVideoFrameRendered, object: player).subscribe { (noti) in
            
            log.info("1111")
            
            }.addDisposableTo(disposeBag)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit{
        
        log.debug("\(String.init(describing: type(of: self))) ---> 被销毁 ")
        
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
