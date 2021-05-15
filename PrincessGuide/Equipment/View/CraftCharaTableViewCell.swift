//
//  CraftCharaTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Reusable

protocol CraftCharaTableViewCellDelegate: AnyObject {
    func craftCharaTableViewCell(_ craftCharaTableViewCell: CraftCharaTableViewCell, didSelect index: Int)
}

class CraftCharaTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Reusable {
    
    let titleLabel = UILabel()
    let layout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    weak var delegate: CraftCharaTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = Theme.dynamic.color.title
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        titleLabel.text = NSLocalizedString("Who Needs", comment: "")
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        layout.itemSize = CGSize(width: 64, height: 92)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(92)
            make.bottom.equalToSuperview()
        }
        
        collectionView.register(CraftSummaryCollectionViewCell.self, forCellWithReuseIdentifier: CraftSummaryCollectionViewCell.description())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Item {
        var number: Int
        var url: URL
    }
    
    private var items = [Item]()
    
    func configure(for items: [Item]) {
        self.items = items
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.craftCharaTableViewCell(self, didSelect: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CraftSummaryCollectionViewCell.description(), for: indexPath) as! CraftSummaryCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(url: item.url, number: item.number)
        return cell
    }
}
