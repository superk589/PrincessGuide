//
//  PromotionView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class PromotionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let layout: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        layout.itemSize = CGSize(width: 64, height: 64)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(84)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.register(PromotionCollectionViewCell.self, forCellWithReuseIdentifier: PromotionCollectionViewCell.description())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotion?.equipSlots.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCollectionViewCell.description(), for: indexPath) as! PromotionCollectionViewCell
        guard let id = promotion?.equipSlots[indexPath.item] else {
            fatalError()
        }
        cell.configure(for: id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = promotion?.equipSlots[indexPath.item] {
            // TODO: call delegation or closure here
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var promotion: Card.Promotion?
    
    func configure(for promotion: Card.Promotion) {
        self.promotion = promotion
        collectionView.reloadData()
    }
    
}
