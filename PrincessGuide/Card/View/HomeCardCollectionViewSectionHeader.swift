//
//  HomeCardCollectionViewSectionHeader.swift
//  PrincessGuide
//
//  Created by zzk on 6/2/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit
import Reusable

class HomeCardCollectionViewSectionHeader: UICollectionReusableView, Reusable {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = Theme.dynamic.color.title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(layoutMarginsGuide).offset(4)
        }
        
        let effect = UIBlurEffect.init(style: .systemMaterial)
        let effectView = UIVisualEffectView(effect: effect)
        insertSubview(effectView, at: 0)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
