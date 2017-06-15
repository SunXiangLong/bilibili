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
    
    @IBOutlet weak var srcHeightConsraint: NSLayoutConstraint!
    @IBOutlet weak var name: YYLabel!
    @IBOutlet weak var heightCS: NSLayoutConstraint!
    @IBOutlet weak var liveOnline: YYLabel!
    @IBOutlet weak var liveTitle: YYLabel!
    @IBOutlet weak var src: AnimatableImageView!
    
    var isAreaHidden = false
    
    var model:livesModel?{
        didSet{
            
            liveTitle.displaysAsynchronously = true
            name.displaysAsynchronously = true
            liveOnline.displaysAsynchronously = true
            
            if  model!.area  != "" {
                self.src.contentMode = .center
                src.kf.setImage(with: model?.cover.src, placeholder: #imageLiteral(resourceName: "livebase_default_img"), options: nil, progressBlock: nil) { (image, error, type, url) in
                    
                    self.src.contentMode = .scaleToFill
                }
                
            }else{
                self.src.contentMode = .center
                src.kf.setImage(with: model?.cover.src, placeholder: #imageLiteral(resourceName: "livebase_default_img"), options: nil, progressBlock: nil) { (image, error, type, url) in
                    
                    self.src.contentMode = .scaleToFill
                }
                
                
            }
        
            name.text = model?.owner.name
            let font = UIFont.init(name: HN, size: 10);
            let attachment  = NSMutableAttributedString.yy_attachmentString(withContent: #imageLiteral(resourceName: "live_eye_ico").imageWithTintColor(tintColor: UIColor.white, blendMode: .overlay), contentMode: .center, attachmentSize: CGSize.init(width: #imageLiteral(resourceName: "live_eye_ico").size.width, height: 14), alignTo: font!, alignment: .center)
            attachment.yy_color = UIColor.white
            attachment.yy_appendString(" " + String.init(stringInterpolationSegment: (model?.online)!));
            
            liveOnline.attributedText = attachment
            let height =  YYTextHeight(liveTitle, model: model)
            heightCS.constant  =  height > 24 ? 40:height
            if  height > 24 {
                let modifier = YYTextLinePositionSimpleModifier()
                modifier.fixedLineHeight = 24
                liveOnline.linePositionModifier = modifier
            }else{
                let modifier = YYTextLinePositionSimpleModifier()
                modifier.fixedLineHeight = 40;
                liveOnline.linePositionModifier = modifier
            }
            
            
            
            
        }
    }
    public func YYTextHeight(_ lable:YYLabel?,model:livesModel?) -> CGFloat{
        
        if  model!.area  != "" && isAreaHidden{
            
            let liveLightStr = "#" + model!.area + "#" as NSString
            let liveStr = (liveLightStr as String) + (model?.title)! as NSString
            let range = liveStr.localizedStandardRange(of: liveLightStr as String)
            let liveText =  NSMutableAttributedString.init(string: "\(String(describing: liveStr))")
            liveText.yy_alignment   = .left
            liveText.yy_font = UIFont.init(name: HN, size: 14)
            liveText.yy_color = UIColor(red:32/255.0, green:32/255.0, blue:32/255.0, alpha: 1)
            liveText.yy_backgroundColor = UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            liveText.yy_setTextHighlight(range, color: UIColor(red:248/255.0, green:131/255.0, blue:163/255.0, alpha: 1), backgroundColor: UIColor.white) { (view, text, range, rect) in
                log.debug(text);
            }
            lable?.backgroundColor =  UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            lable?.attributedText = liveText
            let layout =  YYTextLayout.init(containerSize: CGSize.init(width: self.mj_w, height:  CGFloat(MAXFLOAT)), text: liveText)
            return layout!.textBoundingSize.height
        }else{
            let liveText =  NSMutableAttributedString.init(string: model!.title)
            liveText.yy_alignment   = .left
            liveText.yy_font = UIFont.init(name: HN, size: 14)
            liveText.yy_color = UIColor(red:32/255.0, green:32/255.0, blue:32/255.0, alpha: 1)
            liveText.yy_backgroundColor = UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            lable?.backgroundColor =  UIColor(red:244/255.0, green:244/255.0, blue:244/255.0, alpha: 1)
            lable?.attributedText = liveText
            let layout =  YYTextLayout.init(containerSize: CGSize.init(width: self.mj_w, height:  CGFloat(MAXFLOAT)), text: liveText)
            return layout!.textBoundingSize.height
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        srcHeightConsraint.constant =  (UIScreenWidth - 30)*0.5*18/32

    }
}
