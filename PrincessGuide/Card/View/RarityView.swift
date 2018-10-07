//
//  RarityView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class RarityView: UIView {
    
    private var starViews = [UIImageView]()
    
    var image: UIImage {
        return #imageLiteral(resourceName: "loading_star").withRenderingMode(.alwaysTemplate)
    }
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<5 {
            let view = UIImageView()
            view.tintColor = .rarityStar
            starViews.append(view)
            view.snp.makeConstraints { (make) in
                make.height.equalTo(view.snp.width)
            }
            view.image = image
        }
        
        starViews.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.lessThanOrEqualTo(14)
        }
        
        transform = CGAffineTransform(scaleX: -1, y: 1)
        
    }
    
    func setup(stars: Int) {
        assert(0...5 ~= stars)
        starViews[0..<stars].forEach {
            stackView.addArrangedSubview($0)
        }
        starViews[stars..<5].forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ShadowRarityView: RarityView {
    override var image: UIImage {
        return #imageLiteral(resourceName: "shadow_star").withRenderingMode(.alwaysOriginal)
    }
}
