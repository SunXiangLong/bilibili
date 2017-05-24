//
//  SXLaunxhViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/17.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit

class SXLaunxhViewController: UIViewController {

    
    @IBOutlet weak var defaltImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var defaltImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var defaultImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImageView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.7);
        
        defaltImageViewWidth.constant = 0
        defaltImageViewHeight.constant = 0
        self.view.layoutIfNeeded()
        //没有其他逻辑最简单的 一般会有广告也等等 是否第一次进入 或根据接口返回数据判断等情况
        launchWithAnimate()

        // Do any additional setup after loading the view.
    }
    func launchWithAnimate(){
        
        defaultImageView.isHidden = false
        defaltImageViewWidth.constant = 300
        defaltImageViewHeight.constant = 440
        
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 8.0, options: UIViewAnimationOptions(rawValue: 0), animations: { 
            self.defaultImageView.layoutIfNeeded()
        }) { (bool) in
            DispatchQueue.init(label: "com.sunxianglong.www", qos: .userInitiated).asyncAfter(deadline: .now()+0.5, execute: { 
                
                DispatchQueue.main.async(execute: { 
                    let tabBar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController");
                    UIApplication.shared.keyWindow?.rootViewController = tabBar
                    UIApplication.shared.keyWindow?.sendSubview(toBack: tabBar.view)
                })
            })
            
           
        }
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
