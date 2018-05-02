//
//  LoadingHUD.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LoadingHUD: UIView {
    
    let imageView = LoadingImageView(frame: CGRect(x: 35, y: 20, width: 50, height: 50))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 75, width: 120, height: 25))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        isUserInteractionEnabled = true
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 17)
        titleLabel.textColor = .white
        titleLabel.text = NSLocalizedString("Please wait", comment: "")
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        alpha = 0
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoadingHUDManager {
    
    static let `default` = LoadingHUDManager()
    let hud = LoadingHUD()
    
    let debouncer = Debouncer(interval: 0.1)
    
    private init () {
        
    }
    
    private lazy var showClosure: (() -> Void)? = { [unowned self] in
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.hud)
            self.hud.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            for subview in window.subviews {
                if subview is UpdatingHUD {
                    window.bringSubview(toFront: subview)
                }
            }
            self.hud.alpha = 1
        }
    }
    
    func show(text: String = NSLocalizedString("Please wait", comment: "")) {
        hud.setup(title: text)
        debouncer.callback = showClosure
        debouncer.call()
    }
    
    func hide() {
        debouncer.callback = nil
        hud.alpha = 0
        hud.removeFromSuperview()
    }
}

