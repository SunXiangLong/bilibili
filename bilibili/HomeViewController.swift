//
//  HomeViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/18.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit

import SwiftyJSON

class HomeViewControlvar: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func setUI() {
        topView.snp.makeConstraints {
            $0.centerX.equalTo(UIScreenWidth*0.5)
            $0.width.equalTo(132);
            $0.height.equalTo(44);
            $0.bottom.equalTo(0);
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
