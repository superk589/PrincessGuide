//
//  VLTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class VLTableViewCell: UITableViewCell {
    
    let contentLabel = UILabel()
    
    let scheduleIndicator = TimeStatusIndicator()
    
    let scheduleLabel = UILabel()
    
    private let topView = UIStackView()
    
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentLabel.textColor = Theme.dynamic.color.body
        scheduleLabel.textColor = Theme.dynamic.color.caption
        
        topView.axis = .horizontal
        topView.spacing = 5
        scheduleLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        scheduleLabel.numberOfLines = 2
        topView.addArrangedSubview(scheduleIndicator)
        topView.addArrangedSubview(scheduleLabel)
        scheduleIndicator.setContentHuggingPriority(.required, for: .horizontal)
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(contentLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentLabel.numberOfLines = 0
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        selectionStyle = .none
    }
    
    func configure(for data: VLElement) {
        if let schedule = data.schedule {
            topView.isHidden = false
            let now = Date()
            if schedule.startDate > now {
                scheduleIndicator.style = .future
            } else if schedule.endDate < now {
                scheduleIndicator.style = .past
            } else {
                scheduleIndicator.style = .now
            }
            scheduleLabel.text = schedule.description
        } else {
            topView.isHidden = true
        }
        contentLabel.text = data.content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
