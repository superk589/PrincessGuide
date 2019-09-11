//
//  PatternCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import Reusable

class PatternCollectionViewCell: UICollectionViewCell, Reusable {
    
    let skillIcon = IconImageView()
    
    let skillLabel = UILabel()
    
    let loopLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        skillLabel.textColor = Theme.dynamic.color.caption
        loopLabel.textColor = Theme.dynamic.color.caption
        
        contentView.addSubview(skillIcon)
        skillIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        contentView.addSubview(skillLabel)
        skillLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        skillLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(skillIcon.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        contentView.addSubview(loopLabel)
        loopLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(skillIcon.snp.top).offset(-5)
            make.top.greaterThanOrEqualTo(10)
        }
        loopLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
    }
    
    func configure(for item: CDPatternTableViewCell.Item) {
        switch item.iconType {
        case .magicalSwing:
            skillIcon.configure(iconURL: URL.resource.appendingPathComponent("icon/equipment/101251.webp"), placeholderStyle: .questionMark)
        case .physicalSwing:
            skillIcon.configure(iconURL: URL.resource.appendingPathComponent("icon/equipment/101011.webp"), placeholderStyle: .questionMark)
        case .skill(let id):
            skillIcon.configure(iconURL: URL.resource.appendingPathComponent("icon/skill/\(id).webp"), placeholderStyle: .questionMark)
        default:
            skillIcon.configure(iconURL: nil, placeholderStyle: .questionMark)
        }
        skillLabel.text = item.text
        switch item.loopType {
        case .start:
            loopLabel.text = NSLocalizedString("Loop start", comment: "")
        case .end:
            loopLabel.text = NSLocalizedString("Loop end", comment: "")
        case .inPlace:
            loopLabel.text = NSLocalizedString("Loop in place", comment: "")
        case .none:
            loopLabel.text = ""
        }
    }
 
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64 + skillLabel.font.lineHeight + loopLabel.font.lineHeight + 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
