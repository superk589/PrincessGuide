//
//  CDPatternTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import SnapKit
import Reusable

class CDPatternTableViewCell: UITableViewCell, Reusable, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLabel = UILabel()
    var layout: UICollectionViewFlowLayout
    var collectionView: UICollectionView
    var collectionViewHeightConstraint: Constraint?
    var observation: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.collectionView.indicatorStyle = theme.indicatorStyle
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")

        selectionStyle = .none
        
        let cellHeight: CGFloat = 123
        layout.itemSize = CGSize(width: 64, height: cellHeight)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.left.equalTo(readableContentGuide)
            make.bottom.equalToSuperview().priority(999)
            collectionViewHeightConstraint = make.height.equalTo(cellHeight).constraint
        }
        
        collectionView.register(PatternCollectionViewCell.self, forCellWithReuseIdentifier: PatternCollectionViewCell.description())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        observation = collectionView.observe(\.contentSize) { (collectionView, _) in
            self.collectionViewHeightConstraint?.update(offset: collectionView.contentSize.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, items: [Item]) {
        titleLabel.text = title
        self.items = items
        collectionView.reloadData()
        layoutIfNeeded()
    }
    
    struct Item {
        enum IconType {
            case magicalSwing
            case physicalSwing
            case skill(Int)
            case unknown
        }
        enum LoopType {
            case start
            case end
            case inPlace
            case none
        }
        let iconType: IconType
        let loopType: LoopType
        let text: String
    }
    
    var items: [Item] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PatternCollectionViewCell.description(), for: indexPath) as! PatternCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(for: item)
        return cell
    }
}
