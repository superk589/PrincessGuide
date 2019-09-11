//
//  DropSummaryTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class DropSummaryTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    
    let typeLabel = UILabel()

    let collectionView = TTGTagCollectionView()
    
    var tagViews = [Int: DropRewardView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = Theme.dynamic.color.title
        typeLabel.textColor = Theme.dynamic.color.lightText
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        
        typeLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(readableContentGuide)
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
    
    private var rewards = [Drop.Reward]()
    private var focusedID: Int?
    func configure(for quest: Quest, focusedID: Int? = nil) {
        rewards = quest.allRewards.sorted { $0.odds > $1.odds }
        self.focusedID = focusedID
        titleLabel.text = quest.base.questName
        typeLabel.text = quest.areaType.description
        collectionView.reload()
    }
    
//    func configure(for wave: Wave, index: Int, focusedID: Int? = nil) {
//        rewards = wave.drops.flatMap { $0.rewards }.sorted { $0.odds > $1.odds }
//        self.focusedID = focusedID
//        titleLabel.text = String(format: NSLocalizedString("Wave %d", comment: ""), index + 1)
//        typeLabel.text = ""
//        collectionView.reload()
//    }
}

extension DropSummaryTableViewCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    private func dequeueTagView(for index: Int) -> UIView {
        if let view = tagViews[index] {
            return view
        } else {
            let view = DropRewardView()
            tagViews[index] = view
            return view
        }
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(rewards.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let view = dequeueTagView(for: Int(index)) as! DropRewardView
        let reward = rewards[Int(index)]
        view.configure(for: rewards[Int(index)], isFocused: reward.rewardID == focusedID)
        return view
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return dequeueTagView(for: Int(index)).intrinsicContentSize
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        
    }
    
}
