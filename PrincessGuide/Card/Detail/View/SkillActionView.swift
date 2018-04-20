//
//  SkillActionView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class SkillActionView: UIView {
    
    let typeLabel = UILabel()
    
    var actionValueViews = [SkillActionValueView]()
    
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        typeLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        addSubview(typeLabel)
        stackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(typeLabel.snp.bottom)
        }
        
    }
    
    func configure(for action: Skill.Action) {
        actionValueViews.forEach {
            stackView.removeArrangedSubview($0)
        }
        actionValueViews.removeAll()
        
        for info in action.values {
            let actionValueView = SkillActionValueView()
            actionValueView.configure(title: info.key.description, value: info.value)
            actionValueViews.append(actionValueView)
            stackView.addArrangedSubview(actionValueView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
