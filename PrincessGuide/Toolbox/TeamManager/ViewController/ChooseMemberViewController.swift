//
//  ChooseMemberViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt
import SwiftyJSON

class ChooseCardsViewController: CardCollectionViewController {
    
    var selectedCards = [Selected]()
    
    struct Selected {
        var card: Card
        var indexPath: IndexPath
    }
    
    let candidateView = CandidateCardsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Create Team", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .plain, target: self, action: #selector(nextStep(_:)))
        
        view.addSubview(candidateView)
        
        candidateView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
        }
        
        candidateView.delegate = self
    }
    
    @objc private func nextStep(_ item: UIBarButtonItem) {
        let vc = EditTeamViewController(cards: selectedCards.map { $0.card })
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell {
            if cell.isEnable {
                if selectedCards.count < 5 {
                    cell.isEnable = false
                    let card = sortedCards[indexPath.item]
                    
                    selectedCards.append(Selected(card: card, indexPath: indexPath))
                    selectedCards.sort { $0.card.base.searchAreaWidth > $1.card.base.searchAreaWidth }
                    candidateView.configure(for: selectedCards.map { $0.card })
                }
            } else {
                cell.isEnable = true
                let card = sortedCards[indexPath.item]
                if let index = selectedCards.index(where: { $0.card.base.unitId == card.base.unitId }) {
                    selectedCards.remove(at: index)
                    candidateView.configure(for: selectedCards.map { $0.card })
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! CardCollectionViewCell
        
        let card = sortedCards[indexPath.item]
        if selectedCards.contains(where: { $0.card.base.unitId == card.base.unitId }) {
            cell.isEnable = false
        } else {
            cell.isEnable = true
        }
        return cell
    }
    
}

extension ChooseCardsViewController: CandidateCardsViewDelegate {
    func candidateCardsView(_ candidateCardsView: CandidateCardsView, didSelect index: Int) {
        let selected = selectedCards.remove(at: index)
        candidateCardsView.configure(for: selectedCards.map { $0.card })
        if let index = sortedCards.index(where: { $0.base.unitId == selected.card.base.unitId }) {
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
}
