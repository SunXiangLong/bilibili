//
//  LiveCollectionViewCell.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/23.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import YYText
import IBAnimatable
import Kingfisher
class LiveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: YYLabel!
    @IBOutlet weak var heightCS: NSLayoutConstraint!
    @IBOutlet weak var liveOnline: YYLabel!
    @IBOutlet weak var liveTitle: YYLabel!
    @IBOutlet weak var src: AnimatableImageView!
    var model:livesModel?{
        didSet{
            src.kf.setImage(with: model?.cover?.src, placeholder: #imageLiteral(resourceName: "livebase_default_img"), options: nil, progressBlock: nil) { (image, error, type, url) in
                
                self.src.contentMode = .scaleAspectFill
            }
           
            name.text = model?.owner?.name
          
            
            let font = UIFont.init(name: HN, size: 10);
            let attachment  = NSMutableAttributedString.yy_attachmentString(withContent: #imageLiteral(resourceName: "live_eye_ico").imageWithTintColor(tintColor: UIColor.white, blendMode: .overlay), contentMode: .center, attachmentSize: CGSize.init(width: #imageLiteral(resourceName: "live_eye_ico").size.width, height: 14), alignTo: font!, alignment: .center)
            attachment.yy_color = UIColor.white
            attachment.yy_appendString(" " + String.init(stringInterpolationSegment: (model?.online)!));
            liveOnline.attributedText = attachment
            
            heightCS.constant = 35
            _ =  YYTextHeight(liveTitle, model: model)
        
         
        }
    }
    public func YYTextHeight(_ lable:YYLabel?,model:livesModel?) -> CGFloat{
    
        let liveLightStr = "#" + (model?.area)! + "#" as NSString
        let liveStr = (liveLightStr as String) + (model?.title)! as NSString
        let range = liveStr.localizedStandardRange(of: liveLightStr as String)
        let liveText =  NSMutableAttributedString.init(string: "\(String(describing: liveStr))")
        liveText.yy_alignment   = .left
        liveText.yy_font = UIFont.init(name: HN, size: 12)
        liveText.yy_color = UIColor(red:32/255.0, green:32/255.0, blue:32/255.0, alpha: 1)
        liveText.yy_setTextHighlight(range, color: UIColor(red:248/255.0, green:131/255.0, blue:163/255.0, alpha: 1), backgroundColor: UIColor.white) { (view, text, range, rect) in
            print("点击了\(text)")
        }
        lable?.attributedText = liveText

        let layout =  YYTextLayout.init(containerSize: CGSize.init(width: self.mj_w, height:  CGFloat(MAXFLOAT)), text: liveText)
       
        return (layout?.textBoundingSize.height)!
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        liveTitle.displaysAsynchronously = true
        name.displaysAsynchronously = true
        liveOnline.displaysAsynchronously = true
        self.src.contentMode = .center
        heightCS.constant = 0

 
    }
}
