//
//  EaseViewController.swift
//  bilibili
//
//  Created by xiaomabao on 2017/6/27.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import Hyphenate
class EaseViewController: EaseConversationListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showRefreshHeader = true;
        //首次进入加载数据
        self.tableViewDidTriggerFooterRefresh()
        
        let text = EMTextMessageBody.init(text: "hahahhahahahahahah")
        let meg = EMMessage.init(conversationID: "xiang", from: "sun", to: "xiang", body: text!, ext: ["em_force_notification":NSNumber.init(booleanLiteral: true)])
        
        meg?.chatType = EMChatTypeChat
        EMClient.shared().chatManager.send(meg, progress: { (intss) in
             log.debug(intss)
        }, completion: { (meg, error) in
            if error != nil{
                log.error(error.debugDescription)
                
            }else{
                
                log.debug(meg!.body)
            }
        })
        
        

        
        
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
