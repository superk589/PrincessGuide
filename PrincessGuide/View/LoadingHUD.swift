//
//  LoadingHUD.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Gestalt

class LoadingHUD: UIView {
    
    let loadingView = LoadingView(frame: CGRect(x: 35, y: 20, width: 50, height: 50))
    let errorView = ErrorView(frame: CGRect(x: 35, y: 20, width: 50, height: 50))
    let completionView = CompletionView(frame: CGRect(x: 35, y: 20, width: 50, height: 50))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 75, width: 120, height: 25))
    let contentView = UIView()
    
    enum Style {
        case loading
        case completion
        case error
    }
    
    var style = Style.loading {
        didSet {
            switch style {
            case .completion:
                loadingView.isHidden = true
                completionView.isHidden = false
                errorView.isHidden = true
            case .loading:
                loadingView.isHidden = false
                completionView.isHidden = true
                errorView.isHidden = true
            case .error:
                loadingView.isHidden = true
                completionView.isHidden = true
                errorView.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundColor = theme.color.loadingHUD.background
            themeable.titleLabel.textColor = theme.color.loadingHUD.text
            themeable.contentView.backgroundColor = theme.color.loadingHUD.foreground
        }
        
        isUserInteractionEnabled = true
        
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
        titleLabel.text = NSLocalizedString("Please wait", comment: "")
        
        contentView.addSubview(loadingView)
        contentView.addSubview(completionView)
        contentView.addSubview(errorView)
        completionView.isHidden = true
        errorView.isHidden = true
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
    
    let debouncer = Debouncer(interval: 0.2)
    
    private init () {
        
    }
    
    private lazy var showClosure: (() -> Void) = { [unowned self] in
        if let window = UIApplication.shared.currentWindow {
            window.addSubview(self.hud)
            self.hud.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            for subview in window.subviews {
                if subview is UpdatingHUD {
                    window.bringSubviewToFront(subview)
                }
            }
            self.hud.alpha = 1
        }
    }
    
    func show(text: String = NSLocalizedString("Please wait", comment: "")) {
        hud.setup(title: text)
        hud.style = .loading
        debouncer.callback = showClosure
        debouncer.call()
    }
    
    func showCheckMark(text: String = NSLocalizedString("Completed", comment: ""), dismissedAfter second: TimeInterval = 1.35) {
        hud.setup(title: text)
        hud.style = .completion
        showClosure()
        hud.completionView.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + second) { [unowned self] in
            self.hide()
        }
    }
    
    func showErrorMark(text: String = NSLocalizedString("Error", comment: ""), dismissAfter second: TimeInterval = 1.35) {
        hud.setup(title: text)
        hud.style = .error
        showClosure()
        hud.errorView.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + second) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        debouncer.callback = nil
        hud.alpha = 0
        hud.removeFromSuperview()
    }
}

