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

class CDPatternTableViewCell: UITableViewCell, CardDetailConfigurable, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func configure(for item: CardDetailItem) {
        guard case .pattern(let pattern, let card, let index) = item else { return }
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
        let items: [Item] = pattern.items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: Item.IconType
            let loopType: Item.LoopType
            let text: String
            switch item {
            case 1:
                if card.base.atkType == 2 {
                    iconType = .magicalSwing
                } else {
                    iconType = .physicalSwing
                }
                text = NSLocalizedString("Swing", comment: "")
            case 1000..<2000:
                let index = item - 1001
                let skillID = card.base.mainSkillIDs[index]
                if let iconID = card.mainSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("Main %d", comment: "")
                text = String(format: format, index + 1)
            case 2000..<3000:
                let index = item - 2001
                let skillID = card.base.spSkillIDs[index]
                if let iconID = card.spSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("SP %d", comment: "")
                text = String(format: format, index + 1)
            default:
                iconType = .unknown
                text = NSLocalizedString("Unknown", comment: "")
            }
            
            switch offset {
            case pattern.loopStart - 1:
                if pattern.loopStart == pattern.loopEnd {
                    loopType = .inPlace
                } else {
                    loopType = .start
                }
            case pattern.loopEnd - 1:
                loopType = .end
            default:
                loopType = .none
            }
            
            return Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }
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

extension CDPatternTableViewCell: MinionDetailConfigurable {
    func configure(for item: MinionDetailItem) {
        guard case .pattern(let pattern, let minion, let index) = item else { return }
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
        let items: [Item] = pattern.items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: Item.IconType
            let loopType: Item.LoopType
            let text: String
            switch item {
            case 1:
                if minion.base.atkType == 2 {
                    iconType = .magicalSwing
                } else {
                    iconType = .physicalSwing
                }
                text = NSLocalizedString("Swing", comment: "")
            case 1000..<2000:
                let index = item - 1001
                let skillID = minion.base.mainSkillIDs[index]
                if let iconID = minion.mainSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("Main %d", comment: "")
                text = String(format: format, index + 1)
            case 2000..<3000:
                let index = item - 2001
                let skillID = minion.base.spSkillIDs[index]
                if let iconID = minion.spSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("SP %d", comment: "")
                text = String(format: format, index + 1)
            default:
                iconType = .unknown
                text = NSLocalizedString("Unknown", comment: "")
            }
            
            switch offset {
            case pattern.loopStart - 1:
                if pattern.loopStart == pattern.loopEnd {
                    loopType = .inPlace
                } else {
                    loopType = .start
                }
            case pattern.loopEnd - 1:
                loopType = .end
            default:
                loopType = .none
            }
            
            return Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }

        self.items = items
        collectionView.reloadData()
        layoutIfNeeded()
    }
}
