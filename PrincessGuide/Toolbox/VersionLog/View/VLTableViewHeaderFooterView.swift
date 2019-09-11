//
//  VLTableViewHeaderFooterView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class VLTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    let versionLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let backgroundEffectView = UIVisualEffectView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = backgroundEffectView
        
        backgroundEffectView.effect = UIBlurEffect(style: .systemMaterial)
        timeLabel.textColor = Theme.dynamic.color.lightText
        versionLabel.textColor = Theme.dynamic.color.title
        
        contentView.addSubview(timeLabel)
        timeLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(5)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        versionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(timeLabel.snp.bottom)
        }
    }
    
    // reference: https://stackoverflow.com/questions/17581550/uitableviewheaderfooterview-subclass-with-auto-layout-and-section-reloading-won
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if newValue == .zero {
                return
            } else {
                super.frame = newValue
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subTitle: String) {
        versionLabel.text = title
        timeLabel.text = subTitle
    }

}
