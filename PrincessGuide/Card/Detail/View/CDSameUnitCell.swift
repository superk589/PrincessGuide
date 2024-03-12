//
//  CDSameUnitCell.swift
//  PrincessGuide
//
//  Created by zzk on 2024/3/12.
//  Copyright © 2024 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import AlignedCollectionViewFlowLayout

protocol CDSameUnitCellDelegate: AnyObject {
    func cdSameUnitCell(_ cdSameUnitCell: CDSameUnitCell, didSelect index: Int)
}

class CDSameUnitCell: UITableViewCell, Reusable, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: CDSameUnitCellDelegate?
    let titleLabel = UILabel()
    var layout: AlignedCollectionViewFlowLayout
    var collectionView: UICollectionView
    var collectionViewHeightConstraint: Constraint?
    var observation: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = Theme.dynamic.color.title
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        titleLabel.text = NSLocalizedString("Same Unit", comment: "")
        
        selectionStyle = .none
        
        let cellHeight: CGFloat = 64
        layout.itemSize = CGSize(width: 64, height: cellHeight)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.left.equalTo(readableContentGuide)
            make.bottom.equalTo(-10).priority(999)
            collectionViewHeightConstraint = make.height.equalTo(cellHeight).constraint
        }
        
        collectionView.register(cellType: CardCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        observation = collectionView.observe(\.contentSize) { [weak self] (collectionView, _) in
            self?.collectionViewHeightConstraint?.update(offset: collectionView.contentSize.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(items: [Card]) {
        self.items = items
        collectionView.reloadData()
        layoutIfNeeded()
    }
    
    var items: [Card] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CardCollectionViewCell.self)
        let item = items[indexPath.item]
        cell.configure(for: item, isEnable: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cdSameUnitCell(self, didSelect: indexPath.item)
    }
}
