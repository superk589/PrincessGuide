//
//  UpdatingHUD.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Gestalt

class UpdatingHUD: UIView {
    
    let statusLabel = UILabel()
    private let loadingView = LoadingImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.backgroundColor = theme.color.loadingHUD.foreground
            themable.statusLabel.textColor = theme.color.loadingHUD.text
        }
        
        loadingView.hideWhenStopped = true
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(loadingView.snp.right)
            make.centerX.equalToSuperview()
        }
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 17)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.baselineAdjustment = .alignCenters
    }
    
    private var isShowing = false
    
    func show() {
        isShowing = true
        stopFading()
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
            snp.remakeConstraints { (make) in
                make.width.equalTo(240)
                make.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-95)
            }
        }
    }
    
    func hide(animated: Bool) {
        isShowing = false
        stopAnimating()
        if animated {
            layer.removeAllAnimations()
            UIView.animate(withDuration: 2.5, animations: { [weak self] in
                self?.alpha = 0
            }) { [weak self] (finished) in
                self?.alpha = 1
                if let strongSelf = self, !strongSelf.isShowing {
                    self?.removeFromSuperview()
                }
            }
        } else {
            removeFromSuperview()
        }
    }
    
    private var isAnimating = false
    
    private func startAnimating() {
        isAnimating = true
        loadingView.startAnimating()
    }
    
    private func stopAnimating() {
        isAnimating = false
        loadingView.stopAnimating()
    }
    
    private func stopFading() {
        layer.removeAllAnimations()
    }
    
    func setup(_ text: String, animated: Bool) {
        if animated && !isAnimating {
            startAnimating()
        }
        statusLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelUpdate() {
        stopAnimating()
        hide(animated: false)
    }
    
}

class UpdatingHUDManager {
    
    static let shared = UpdatingHUDManager()
    
    let updatingHUD = UpdatingHUD()
    
    private init() {

    }
    
    func show() {
        updatingHUD.show()
    }
    
    func hide(animated: Bool) {
        updatingHUD.hide(animated: animated)
    }
    
    func setup(_ text: String, animated: Bool) {
        updatingHUD.setup(text, animated: animated)
    }
    
    func setup(current: Int, total: Int, animated: Bool) {
        updatingHUD.setup("\(current)/\(total)", animated: animated)
    }
    
}
