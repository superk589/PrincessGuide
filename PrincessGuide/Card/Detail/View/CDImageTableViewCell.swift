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
    func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL)
}

class CDImageTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    static let imageHeight: CGFloat = 100
    
    let titleLabel = UILabel()
    
    let layout: UICollectionViewFlowLayout
    let imageCollectionView: UICollectionView
    
    weak var delegate: CDImageTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        layout = UICollectionViewFlowLayout()
        imageCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 10, height: CDImageTableViewCell.imageHeight), collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
            themable.titleLabel.textColor = theme.color.title
            themable.imageCollectionView.indicatorStyle = theme.indicatorStyle
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        layout.estimatedItemSize = CGSize(width: CDImageTableViewCell.imageHeight * 3 / 2, height: CDImageTableViewCell.imageHeight)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        contentView.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(readableContentGuide)
            make.height.equalTo(CDImageTableViewCell.imageHeight + 2)
            make.bottom.equalTo(-10)
        }
        
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.description())
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.scrollsToTop = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var urls = [URL]()
    func configure(for urls: [URL], title: String) {
        self.urls = urls
        titleLabel.text = title
        imageCollectionView.reloadData()
    }
    
    func configure(for item: CardDetailItem) {
        guard case .album(let title, _, let thumbnailURLs) = item else {
            fatalError()
        }
        configure(for: thumbnailURLs, title: title)
    }
    
}

extension CDImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.description(), for: indexPath) as! ImageCollectionViewCell
        let url = urls[indexPath.item]
        cell.configure(for: url) { [weak self] in
            if cell.url == url {
                self?.imageCollectionView.reloadItems(at: [indexPath])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            return
        }
        delegate?.cdImageTableViewCell(self, didSelect: imageCollectionViewCell.imageView, url: urls[indexPath.item])
    }
}
