//
//  CardWithBirthdayCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka

protocol CardWithBirthdayCellDelegate: AnyObject {
    func cardWithBirthdayCell(_ cardWithBirthdayCell: CardWithBirthdayCell, didSelect card: Card)
}

class CardWithBirthdayCell: Cell<String>, CellType, UICollectionViewDelegate, UICollectionViewDataSource {
        
    let layout = UICollectionViewFlowLayout()
    
    weak var delegate: CardWithBirthdayCellDelegate?
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardWithBirthdayCollectionViewCell.self, forCellWithReuseIdentifier: CardWithBirthdayCollectionViewCell.description())
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.bottom.equalToSuperview()
        }
        layout.itemSize = CGSize(width: 64, height: 78)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.isScrollEnabled = false
        collectionView.scrollsToTop = false        
        collectionView.backgroundColor = .clear
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        selectionStyle = .none
        
        height = { [unowned self] in
            self.layout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
            return max(44, self.collectionView.contentSize.height + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
        }
        
    }
    
    private var cards = [Card]()
    
    func configure(for cards: [Card]) {
        self.cards = cards
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardWithBirthdayCollectionViewCell.description(), for: indexPath) as! CardWithBirthdayCollectionViewCell
        let card = cards[indexPath.item]
        cell.configure(for: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.item]
        delegate?.cardWithBirthdayCell(self, didSelect: card)
    }
    
    override func update() {
        super.update()
        detailTextLabel?.text = nil
    }
    
}

final class CardWithBirthdayRow: Row<CardWithBirthdayCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
