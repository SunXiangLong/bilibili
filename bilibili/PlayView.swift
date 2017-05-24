//
//  PlayView.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/24.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import IJKMediaFramework
enum PlayerViewFullScreenStyle {
    case playerViewFullScreenStylePhoneLive // 手机直播
    case playerViewFullScreenStyleNormal // 普通横屏
}
class PlayView: UIView {
    private var player:IJKMediaPlayback?
    var scaleMode:IJKMPMovieScalingMode?
    var videoUrl:URL{
        didSet{
            
            // 设置Log信息打印
            IJKFFMoviePlayerController.setLogReport(true)
             // 设置Log等级
            IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
            // 检查当前FFmpeg版本是否匹配
            IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
            // IJKFFOptions 是对视频的配置信息
            let options =  IJKFFOptions.byDefault()
            player = IJKFFMoviePlayerController.init(contentURL: videoUrl, with: options)
            player?.view.frame = self.bounds
            player?.scalingMode = scaleMode!
            player?.shouldAutoplay = true
            player?.setPauseInBackground(true)
            self.addSubview((self.player?.view)!)
            
            
        
        }
    }
    
}
