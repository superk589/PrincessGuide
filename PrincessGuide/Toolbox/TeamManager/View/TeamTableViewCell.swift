//
//  TeamTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class TeamTableViewCell: UITableViewCell {
    
    let tagLabel = UILabel()
    
    let stackView = UIStackView()
    
    let markIcon = UIImageView()
    
    var memberViews = [MemberView]()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(markIcon)
        markIcon.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(readableContentGuide)
            make.left.greaterThanOrEqualTo(10)
            make.left.equalTo(readableContentGuide).priority(999)
            make.top.equalTo(10)
            make.height.width.equalTo(15)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(markIcon)
            make.left.equalTo(markIcon.snp.right).offset(5)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(markIcon.snp.bottom).offset(5)
            make.left.greaterThanOrEqualTo(readableContentGuide)
            make.left.greaterThanOrEqualTo(10)
            make.left.equalTo(readableContentGuide).priority(999)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        selectedBackgroundView = UIView()
        multipleSelectionBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.multipleSelectionBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.tintColor = theme.color.tint
            themeable.tagLabel.textColor = theme.color.caption
            themeable.markIcon.tintColor = theme.color.tint
        }
        
        tagLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        (0..<5).forEach { _ in
            let view = MemberView()
            view.snp.makeConstraints { (make) in
                make.height.equalTo(view.snp.width)
            }
            memberViews.append(view)
            stackView.addArrangedSubview(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for team: Team) {
        
        switch team.typedMark {
        case .some(.attack):
            markIcon.image = #imageLiteral(resourceName: "sword").withRenderingMode(.alwaysTemplate)
        case .some(.defend):
            markIcon.image = #imageLiteral(resourceName: "shield").withRenderingMode(.alwaysTemplate)
        default:
            markIcon.image = nil
            break
        }
        
        if team.name == "" {
            tagLabel.text = team.typedTag?.description
        } else {
            tagLabel.text = team.name
        }
                
        let members = team.sortedMembers
        (0..<members.count).forEach {
            let view = memberViews[$0]
            view.configure(for: members[$0])
        }
        (members.count..<5).forEach {
            let view = memberViews[$0]
            view.clear()
        }
        
    }

}
