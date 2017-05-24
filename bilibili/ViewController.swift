//
//  ViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/9.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import IJKMediaFramework
import RxCocoa
import RxSwift
class ViewController: UIViewController {
    let dispose = DisposeBag.init()
    var player:IJKMediaPlayback?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        installMovieNotificationObservers()
        player?.prepareToPlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IJKFFMoviePlayerController.setLogReport(true)
        IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
        
        
        IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
        let options =  IJKFFOptions.byDefault()
        player = IJKFFMoviePlayerController.init(contentURL: URL.init(string: "http://tx.acgvideo.com/1/fe/17350980-1-hd.mp4?txTime=1495014797&platform=iphone&txSecret=f5354d0ab19aefa7e67d214ce2c46952&oi=2000268675&rate=700000"), with: options)
        player?.view.frame = self.view.bounds
        player?.scalingMode = .none
        player?.shouldAutoplay = true
        player?.setPauseInBackground(true)
        self.view.addSubview((self.player?.view)!)
        print(player!)
        player?.view.backgroundColor = UIColor.red
            // Do any additional setup after loading the view, typically from a nib.
    }
    func installMovieNotificationObservers()  {
        NotificationCenter.default.rx.notification(NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player).subscribe { (noti) in
            print(noti)
        }.addDisposableTo(dispose)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

