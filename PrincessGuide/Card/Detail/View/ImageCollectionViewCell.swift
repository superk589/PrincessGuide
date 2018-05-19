//
//  ImageCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import Gestalt

class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.lessThanOrEqualTo(CDImageTableViewCell.imageHeight)
        }
        
        imageView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
        }
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.indicator.color = theme.color.indicator
        }
    }
    
    var url: URL?
    
    func configure(for url: URL, completion: @escaping () -> Void) {
        self.url = url
        indicator.startAnimating()
        imageView.kf.setImage(with: url, options: [.scaleFactor(UIScreen.main.scale)]) { [weak self] _, _, _, _ in
            self?.indicator.stopAnimating()
            completion()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
