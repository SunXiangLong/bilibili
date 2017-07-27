//
//  AppDelegate.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/9.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Hyphenate
public let log = SwiftyBeaver.self
let appkey = "1115170626178308#bilibili"
let apnsCertName = "sunxianglong"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,EMChatManagerDelegate {

    var blockRotation: Bool = false
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let console = ConsoleDestination()
        
        log.addDestination(console)
        let opeions = EMOptions.init(appkey: appkey)
        opeions!.apnsCertName = apnsCertName
        var  error =   EMClient.shared().initializeSDK(with: opeions!)
        if let error = error {
            log.error(error)
        }else{
            log.debug("sdk success")
        }
         error =   EMClient.shared().login(withUsername: "sun", password: "123456")
        if let error = error {
            log.error(error)
        }else{
             EMClient.shared().setApnsNickname("sunxianglong")
             EMClient.shared().pushOptions!.noDisturbStatus = EMPushNoDisturbStatusClose
             EMClient.shared().pushOptions!.displayStyle = EMPushDisplayStyleMessageSummary
            
            
            error =    EMClient.shared().updatePushOptionsToServer()
            
            log.debug("log success")
            
            if let error  = error{
                log.error(error.errorDescription)
                
            }else{
                
                log.debug("pushOptions success")
            }
            
        }
        
        EaseSDKHelper.share().hyphenateApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: appkey, apnsCertName: apnsCertName, otherConfig: [kSDKConfigEnableConsoleLogger:NSNumber.init(value: true)])
        
        apnsRegistered(application: application)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = SXLaunxhViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func apnsRegistered(application: UIApplication) {
        
        
        
        
        application.registerForRemoteNotifications()
        
        let setting = UIUserNotificationSettings.init(types:UIUserNotificationType(rawValue: UIUserNotificationType.RawValue(1 | 2 | 0)) , categories: nil)
        application.registerUserNotificationSettings(setting)
        
    
        
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
    }
    func messagesDidReceive(_ aMessages: [Any]!) {
        log.debug(aMessages)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        log.debug(deviceToken)
        EMClient.shared().bindDeviceToken(deviceToken);
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.debug(error.localizedDescription)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
         EMClient.shared().applicationDidEnterBackground(application)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
         EMClient.shared().applicationWillEnterForeground(application)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      
        return self.blockRotation ? .all:.portrait
    }


}


