//
//  HomeCardCollectionViewController.swift
//  PrincessGuide
//
//  Created by zzk on 6/2/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class HomeCardCollectionViewController: UIViewController, DataChecking, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    var cards = [Card]()
    
    let refresher = RefreshHeader()
    
    typealias Section = HomeCardTableViewController.Section
    
    var sections = [Section]()
    
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        
        if Defaults.downloadAtStart {
            check()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilterChange(_:)), name: .cardSortingSettingsDidChange, object: nil)
        
        collectionView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(cellType: HomeCardCollectionViewCell.self)
        collectionView.register(supplementaryViewType: HomeCardCollectionViewSectionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.backgroundColor = Theme.dynamic.color.background
        
        layout.sectionInsetReference = .fromSafeArea
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: 64, height: 90)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        navigationItem.title = NSLocalizedString("Cards", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))
        
        loadData()
        
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let vc = CardSortingViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .formSheet
        present(nc, animated: true, completion: nil)
    }
    
    private func loadData() {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let cards = Array(Preload.default.cards.values)
            let sections = self?.createSections(settings: CardSortingViewController.Setting.default, cards: cards) ?? []
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.cards = cards
                self?.sections = sections
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func handleFilterChange(_ notification: Notification) {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let strongSelf = self {
                let newSections = strongSelf.createSections(settings: CardSortingViewController.Setting.default, cards: strongSelf.cards)
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.sections = newSections
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        loadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sections.count > 1 {
            return CGSize(width: collectionView.frame.width, height: 28)
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeCardCollectionViewCell.self)
        let card = cardOf(indexPath: indexPath)
        let (mode, text) = card.displayContent(for: CardSortingViewController.Setting.default)
        cell.configure(for: cardOf(indexPath: indexPath), value: text, mode: mode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: HomeCardCollectionViewSectionHeader.self)
        view.titleLabel.text = sections[indexPath.section].title
        return view
    }
    
    func cardOf(indexPath: IndexPath) -> Card {
        return sections[indexPath.section].cards[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cardOf(indexPath: indexPath)
        let vc = CDTabViewController(card: card)
        print("card id: \(card.base.unitId)")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func createSections(settings: CardSortingViewController.Setting, cards: [Card]) -> [Section] {
        var groups = cards.grouped(settings: settings)
        for index in groups.indices {
            groups[index].cards.filter(settings: settings)
            groups[index].cards.sort(settings: settings)
        }
        return groups
    }
}

extension Card {
    func displayContent(for settings: CardSortingViewController.Setting) -> (mode: CardView.Mode, text: String?) {
        let mode: CardView.Mode
        let text: String?
        let card = self
        switch settings.sortingMethod {
        case .atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate, .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery, .accuracy:
            let propertyKey = PropertyKey(rawValue: settings.sortingMethod.rawValue)!
            mode = .text
            text = String(Int(card.property().item(for: propertyKey).value))
        case .rarity:
            mode = .rarity
            text = nil
        case .effectivePhysicalHP:
            mode = .text
            text = String(Int(card.property().effectivePhysicalHP.rounded()))
        case .effectivePhysicalHPNoDodge:
            mode = .text
            text = String(Int(card.property().effectivePhysicalHPNoDodge.rounded()))
        case .effectiveMagicalHP:
            mode = .text
            text = String(Int(card.property().effectiveMagicalHP.rounded()))
        case .swingTime:
            mode = .text
            text = String(card.base.normalAtkCastTime)
        case .attackRange:
            mode = .text
            text = String(card.base.searchAreaWidth)
        case .id:
            mode = .text
            text = String(card.base.unitId)
        case .name:
            mode = .rarity
            text = card.base.unitName
        case .age:
            mode = .text
            text = card.profile.age
        case .height:
            mode = .text
            text = card.profile.height
        case .weight:
            mode = .text
            text = card.profile.weight
        case .combatEffectiveness:
            mode = .text
            text = String(card.combatEffectiveness())
        case .birthday:
            mode = .text
            let format = NSLocalizedString("%@/%@", comment: "")
            text = String(format: format, card.profile.birthMonth, card.profile.birthDay)
        }
        return (mode, text)
    }
}
