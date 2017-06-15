//
//  liveReusableHeaderView.swift
//  bilibili
//
//  Created by xiaomabao on 2017/6/14.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import YYText
class liveReusableHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var partition_count: YYLabel!
    @IBOutlet weak var partition_icon: UIImageView!
    @IBOutlet weak var name: YYLabel!
    var  moreLive:((partitionModel) -> Void)?
    
    var model:partitionModel?{
        didSet{
            
            partition_icon.kf.setImage(with: model?.subIcon.src)
            name.text = model?.name
            
            
            let allStr = "当前" +  "\(String(describing: self.model!.count))" + "个直播，进去看看 " as NSString
            let rangStr = "\(String(describing: self.model!.count))"
            let range = allStr.localizedStandardRange(of: rangStr)
            let liveText =  NSMutableAttributedString.init(string: "\(String(describing: allStr))")
            liveText.yy_alignment   = .right
            liveText.yy_font = UIFont.init(name: HN, size: 14)
            liveText.yy_color = UIColor(red:174/255.0, green:174/255.0, blue:174/255.0, alpha: 1)
            liveText.yy_backgroundColor = UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            liveText.yy_setTextHighlight(range, color: UIColor(red:248/255.0, green:111/255.0, blue:152/255.0, alpha: 1), backgroundColor: UIColor.white, userInfo: nil);
            let attachment  = NSMutableAttributedString.yy_attachmentString(withContent: #imageLiteral(resourceName: "community_more_grey"), contentMode: .center, attachmentSize: CGSize.init(width: #imageLiteral(resourceName: "community_more_grey").size.width+5, height: #imageLiteral(resourceName: "community_more_grey").size.height+5), alignTo: liveText.yy_font!, alignment: .center)
            liveText.append(attachment)
            
            
            self.partition_count.backgroundColor =  UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            self.partition_count.attributedText = liveText
            
        }
        
        
    }
    
func tap()  {
    moreLive!(model!)
}
override func awakeFromNib() {
    super.awakeFromNib()
    partition_count.displaysAsynchronously = true
    name.displaysAsynchronously = true
    name.backgroundColor =  UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
    self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(liveReusableHeaderView.tap)))
    
}
}
