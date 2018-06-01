//
//  CardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh
import Gestalt

class CardTableViewController: UITableViewController, DataChecking {
    
    var cards = [Card]()

    let refresher = RefreshHeader()
    
    let backgroundImageView = UIImageView()
    
    var sortedAndGroupedCards = [String: [Card]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.refresher.arrowImage.tintColor = theme.color.indicator
            themeable.refresher.loadingView.color = theme.color.indicator
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .updateConsoleVariblesEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilterChange(_:)), name: .cardSortingSettingsDidChange, object: nil)
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.description())
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationItem.title = NSLocalizedString("Cards", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sort", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))
        
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
            Master.shared.getCards(callback: { (cards) in
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.cards = cards
                    self?.sortedAndGroupedCards = cards.filter(settings: CardSortingViewController.Setting.default)
                    self?.tableView.reloadData()
                    
                    /* debug */
                    /*let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    if let data = try? encoder.encode(cards.map { [$0.base.unitName: $0.property()] }) {
                        try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_property.json"))
                    }
                     */
                }
            })
        }
    }
    
    @objc private func handleFilterChange(_ notification: Notification) {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let strongSelf = self {
                let newDict = strongSelf.cards.filter(settings: CardSortingViewController.Setting.default)
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.sortedAndGroupedCards = newDict
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedAndGroupedCards.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortedAndGroupedCards.count <= 1 {
            return nil
        } else {
            return Array(sortedAndGroupedCards.keys)[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        ThemeManager.default.apply(theme: Theme.self, to: view) { (themeable, theme) in
            if let view = themeable as? UITableViewHeaderFooterView, !(view.backgroundView is UIVisualEffectView) {
                view.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: theme.blurEffectStyle))
                view.textLabel?.textColor = theme.color.title
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(sortedAndGroupedCards.keys)[section]
        return sortedAndGroupedCards[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
        
        let key = Array(sortedAndGroupedCards.keys)[indexPath.section]
        let card = sortedAndGroupedCards[key]![indexPath.row]
        let (mode, text) = cardViewRightContent(card: card, settings: CardSortingViewController.Setting.default)
        cell.configure(for: card, value: text, mode: mode)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(sortedAndGroupedCards.keys)[indexPath.section]
        let card = sortedAndGroupedCards[key]![indexPath.row]
        let vc = CDTabViewController(card: card)
        print("card id: \(card.base.unitId)")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cardViewRightContent(card: Card, settings: CardSortingViewController.Setting) -> (mode: CardView.Mode, text: String?) {
        let mode: CardView.Mode
        let text: String?
        switch settings.sortingMethod {
        case .atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate, .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery:
            let propertyKey = PropertyKey(rawValue: settings.sortingMethod.rawValue)!
            mode = .text
            text = String(Int(card.property().item(for: propertyKey).value))
        case .rarity:
            mode = .rarity
            text = nil
        case .effectivePhysicalHP:
            mode = .text
            text = String(Int(card.property().effectivePhysicalHP.rounded()))
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
        }
        return (mode, text)
    }
}

extension Array where Element == Card {
    
    func filter(settings: CardSortingViewController.Setting) -> [String: [Card]] {
        var newDict = [String: [Card]]()
        switch settings.groupingMethod {
        case .none:
            newDict["default"] = self
        case .guild:
            for card in self {
                if newDict[card.profile.guild] == nil {
                    newDict[card.profile.guild] = [Card]()
                }
                newDict[card.profile.guild]?.append(card)
            }
        case .attackType:
            let magicKey = NSLocalizedString("Magic", comment: "")
            let physicsKey = NSLocalizedString("Physics", comment: "")
            newDict[magicKey] = [Card]()
            newDict[physicsKey] = [Card]()
            for card in self {
                if card.base.atkType == 1 {
                    newDict[physicsKey]?.append(card)
                } else {
                    newDict[magicKey]?.append(card)
                }
            }
        case .position:
            let frontKey = NSLocalizedString("Vanguard", comment: "")
            let middleKey = NSLocalizedString("Center", comment: "")
            let backKey = NSLocalizedString("Back", comment: "")
            newDict[frontKey] = [Card]()
            newDict[middleKey] = [Card]()
            newDict[backKey] = [Card]()
            for card in self {
                if card.base.searchAreaWidth <= 300 {
                    newDict[frontKey]?.append(card)
                } else if card.base.searchAreaWidth <= 600 {
                    newDict[middleKey]?.append(card)
                } else {
                    newDict[backKey]?.append(card)
                }
            }
        }
        
        let sortingMethod: (Card, Card) -> Bool
        switch settings.sortingMethod {
        case .atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate, .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery:
            let propertyKey = PropertyKey(rawValue: settings.sortingMethod.rawValue)!
            sortingMethod = { $0.property().item(for: propertyKey).value < $1.property().item(for: propertyKey).value }
        case .rarity:
            sortingMethod = { $0.base.rarity < $1.base.rarity }
        case .effectivePhysicalHP:
            sortingMethod = { $0.property().effectivePhysicalHP < $1.property().effectivePhysicalHP }
        case .effectiveMagicalHP:
            sortingMethod = { $0.property().effectiveMagicalHP < $1.property().effectiveMagicalHP }
        case .swingTime:
            sortingMethod = { $0.base.normalAtkCastTime < $1.base.normalAtkCastTime }
        case .attackRange:
            sortingMethod = { $0.base.searchAreaWidth < $1.base.searchAreaWidth }
        case .id:
            sortingMethod = { $0.base.unitId < $1.base.unitId }
        case .name:
            sortingMethod = { $0.base.unitName < $1.base.unitName }
        case .height:
            sortingMethod = { Int($0.profile.height) ?? .max < Int($1.profile.height) ?? .max}
        case .weight:
            sortingMethod = { Int($0.profile.weight) ?? .max < Int($1.profile.weight) ?? .max }
        case .age:
            sortingMethod = { Int($0.profile.age) ?? .max < Int($1.profile.age) ?? .max }
        }
        
        for (key, _) in newDict {
            newDict[key]?.sort(by: sortingMethod)
        }
        
        if !settings.isAscending {
            for (key, _) in newDict {
                newDict[key]?.reverse()
            }
        }
        
        return newDict
    }
}
