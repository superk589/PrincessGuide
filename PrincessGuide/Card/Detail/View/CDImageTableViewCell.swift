//
//  CDImageTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

protocol CDImageTableViewCellDelegate: class {
    func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL?)
}

class CDImageTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    static let imageHeight: CGFloat = 100
    
    let titleLabel = UILabel()
    
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    
    weak var delegate: CDImageTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.titleLabel.textColor = theme.color.title
            themeable.scrollView.indicatorStyle = theme.indicatorStyle
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(CDImageTableViewCell.imageHeight + 10)
            make.bottom.equalTo(-10)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(CDImageTableViewCell.imageHeight)
        }
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var urls = [URL]()
    
    private var imageViews = [CDImageView]()

    func configure(for urls: [URL], title: String) {
        self.urls = urls
        titleLabel.text = title
        
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        urls.forEach {
            let imageView = CDImageView()
            imageView.isUserInteractionEnabled = true
            imageViews.append(imageView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            imageView.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(imageView)
            imageView.configure(for: $0)
        }

    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let imageView = tap.view as? CDImageView {
            delegate?.cdImageTableViewCell(self, didSelect: imageView, url: imageView.url)
        }
    }
    
    func configure(for item: CardDetailItem) {
        guard case .album(let title, _, let thumbnailURLs) = item else {
            fatalError()
        }
        configure(for: thumbnailURLs, title: title)
    }
    
}
