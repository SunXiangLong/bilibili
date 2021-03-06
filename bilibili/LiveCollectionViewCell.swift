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
    @IBOutlet weak var rightCS: NSLayoutConstraint!
    @IBOutlet weak var refreshImage: UIImageView!
    /// 是否是第一个secssion
    var isAreaHidden = false
    
    /// 是否是secssion的最后一个itm
    var isRefresh = false
    var section = 0
    var refreshBlock:((_ isArea:Bool,_ sections:Int)-> Void)?
    var model:livesModel?{
        didSet{
            
            liveTitle.displaysAsynchronously = false
            name.displaysAsynchronously = false
            liveOnline.displaysAsynchronously = false
            
            if isRefresh {
                refreshImage.isHidden = false
                rightCS.constant = refreshImage.mj_w 
            }else{
                 refreshImage.isHidden = true
                rightCS.constant = 5
            }
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
            liveText.yy_backgroundColor = UIColor.white
            liveText.yy_setTextHighlight(range, color: UIColor(red:248/255.0, green:131/255.0, blue:163/255.0, alpha: 1), backgroundColor: UIColor.white) { (view, text, range, rect) in
                log.debug(text);
            }
            lable?.backgroundColor =  UIColor.white
            lable?.attributedText = liveText
            let layout =  YYTextLayout.init(containerSize: CGSize.init(width: self.mj_w, height:  CGFloat(MAXFLOAT)), text: liveText)
            return layout!.textBoundingSize.height
        }else{
            let liveText =  NSMutableAttributedString.init(string: model!.title)
            liveText.yy_alignment   = .left
            liveText.yy_font = UIFont.init(name: HN, size: 14)
            liveText.yy_color = UIColor(red:32/255.0, green:32/255.0, blue:32/255.0, alpha: 1)
            liveText.yy_backgroundColor = UIColor.white
            lable?.backgroundColor =  UIColor.white
            lable?.attributedText = liveText
            let layout =  YYTextLayout.init(containerSize: CGSize.init(width: self.mj_w, height:  CGFloat(MAXFLOAT)), text: liveText)
            return layout!.textBoundingSize.height
        }
        
    }
    
    func refresh()  {
        
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        // 3.将动画添加到layer中
        refreshImage.layer.add(rotationAnim, forKey: nil)
        
        if isAreaHidden{
            self.refreshBlock!(true,section)
        }else{
            self.refreshBlock!(false,section)
            
        }
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        srcHeightConsraint.constant =  (UIScreenWidth - 30)*0.5*18/32
        refreshImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(LiveCollectionViewCell.refresh)))

    }
}
