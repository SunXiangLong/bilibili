//
//  bannerCollectionViewCell.swift
//  bilibili
//
//  Created by xiaomabao on 2017/5/27.
//  Copyright © 2017年 sunxianglong. All rights reserved.
//

import UIKit
import Kingfisher
class bannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    
    var src:URL?{
        didSet{
            bannerImage.kf.setImage(with: src, placeholder: #imageLiteral(resourceName: "livebase_default_img").generateCenterImageWithBgColor(mainPlaceHolderBgColor, bgImageSize: CGSize.init(width: (UIScreenWidth - 3*8)*0.5, height: 120)), options: nil, progressBlock: nil, completionHandler: nil)
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
