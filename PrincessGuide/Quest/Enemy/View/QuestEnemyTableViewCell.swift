//
//  QuestEnemyTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import Gestalt

protocol QuestEnemyTableViewCellDelegate: class {
    func questEnemyTableViewCell(_ questEnemyTableViewCell: QuestEnemyTableViewCell, didSelect enemy: Enemy)
}

class QuestEnemyTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    let collectionView = TTGTagCollectionView()
    
    var tagViews = NSCache<NSNumber, EnemyView>()
    
    weak var delegate: QuestEnemyTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.titleLabel.textColor = theme.color.title
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.verticalSpacing = 10
        collectionView.horizontalSpacing = 10
        collectionView.contentInset = .zero
        collectionView.scrollView.scrollsToTop = false
        collectionView.scrollView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    private var enemies = [Enemy]()
    func configure(for wave: Wave, index: Int) {
        enemies = wave.enemies.compactMap { $0.enemy }
        titleLabel.text = "Wave \(index + 1)"
        collectionView.reload()
    }
}

extension QuestEnemyTableViewCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    private func dequeueTagView(for index: Int) -> UIView {
        if let view = tagViews.object(forKey: NSNumber(value: index)) {
            return view
        } else {
            let view = EnemyView()
            tagViews.setObject(view, forKey: NSNumber(value: index))
            return view
        }
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(enemies.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let view = dequeueTagView(for: Int(index)) as! EnemyView
        let enemy = enemies[Int(index)]
        view.configure(for: enemy)
        return view
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return dequeueTagView(for: Int(index)).intrinsicContentSize
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        let enemy = enemies[Int(index)]
        let vc = EDTabViewController(enemy: enemy)
        delegate?.questEnemyTableViewCell(self, didSelect: enemy)
    }
    
}
