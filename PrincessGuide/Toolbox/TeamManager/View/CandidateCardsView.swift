//
//  TeamView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

protocol CandidateCardsViewDelegate: class {
    func candidateCardsView(_ candidateCardsView: CandidateCardsView, didSelect index: Int)
}

class CandidateCardsView: UIView {
    
    var icons = [IconImageView]()
    
    let stackView = UIStackView()
    
    let backgroundView = UIVisualEffectView()
    
    weak var delegate: CandidateCardsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundView.effect = UIBlurEffect(style: theme.blurEffectStyle)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(10)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            } else {
                make.bottom.equalTo(-10)
            }
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for cards: [Card]) {
        
        icons.forEach {
            $0.removeFromSuperview()
        }
        icons.removeAll()
        
        cards.forEach {
            let icon = IconImageView()
            icon.isUserInteractionEnabled = true
            icon.cardID = $0.iconID(style: .default)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            icon.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(icon)
            icons.append(icon)
            icon.snp.makeConstraints { (make) in
                make.height.equalTo(icon.snp.width)
            }
        }
        
        stackView.layoutIfNeeded()
        
    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let view = tap.view as? IconImageView, let index = icons.index(of: view) {
            delegate?.candidateCardsView(self, didSelect: index)
        }
    }
    
}
