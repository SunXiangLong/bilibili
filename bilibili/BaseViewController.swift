//
//  BaseViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/17.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
protocol Autorotate {
    //横屏
    func landscapeLeft()
    //  竖屏
    func portrait()
    
}
extension Autorotate {

    func landscapeLeft() {
        appDelegate.blockRotation = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func portrait() {
        appDelegate.blockRotation = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}
class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
