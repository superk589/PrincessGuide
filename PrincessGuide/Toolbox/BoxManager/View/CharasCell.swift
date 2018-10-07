//
//  CharasCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt

protocol CharasCellDelegate: class {
    func charasCell(_ charasCell: CharasCell, didSelect chara: Chara)
}

class CharasCell: Cell<[Chara]>, CellType, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: CharasCellDelegate?
    
    let layout = UICollectionViewFlowLayout()
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    
    let charaView = CharaView()
    
    override func setup() {
        super.setup()
        
        selectedBackgroundView = UIView()
        //        preservesSuperviewLayoutMargins = true
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharaCollectionViewCell.self, forCellWithReuseIdentifier: CharaCollectionViewCell.description())
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.bottom.equalToSuperview()
        }
        layout.itemSize = CGSize(width: 64, height: 83)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.scrollsToTop = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        
        selectionStyle = .none
        
        height = { [unowned self] in
            self.layout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
            return max(44, self.collectionView.contentSize.height + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
        }
        
    }
    
    private var charas = [Chara]()
    
    func configure(for box: Box) {
        if let set = box.charas, let charas = set.array as? [Chara] {
            self.charas = charas
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharaCollectionViewCell.description(), for: indexPath) as! CharaCollectionViewCell
        let chara = charas[indexPath.item]
        cell.configure(for: chara)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.charasCell(self, didSelect: charas[indexPath.item])
    }
    
    override func update() {
        super.update()
        detailTextLabel?.text = nil
    }
    
}

final class CharasRow: Row<CharasCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
