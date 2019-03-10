//
//  CDImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import Gestalt

class CDImageView: UIImageView {
    
    let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.indicator.color = theme.color.indicator
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override var intrinsicContentSize: CGSize {
        if image == nil {
            return CGSize(width: CDImageTableViewCell.imageHeight * 3 / 2, height: CDImageTableViewCell.imageHeight)
        } else {
            return image!.size
        }
    }
    
    var url: URL?
    
    func configure(for url: URL, completion: (() -> Void)? = nil) {
        self.url = url
        indicator.startAnimating()
        kf.setImage(with: url, options: [.scaleFactor(UIScreen.main.scale)]) { [weak self] _ in
            self?.indicator.stopAnimating()
            completion?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
