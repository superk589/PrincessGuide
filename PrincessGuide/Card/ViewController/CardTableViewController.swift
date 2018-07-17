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
    
    struct Section {
        var title: String
        var cards: [Card]
    }
    
    var sortedAndGroupedCards = [Section]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
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
            let sortedAndGroupedCards = cards.filter(settings: CardSortingViewController.Setting.default)
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.cards = cards
                self?.sortedAndGroupedCards = sortedAndGroupedCards
                self?.tableView.reloadData()
                    
                /* debug */
                /*let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(cards.map { [$0.base.unitName: $0.property()] }) {
                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_property.json"))
                }
                 */
                
                /*
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let settings = CDSettingsViewController.Setting.default
                if let data = try? encoder.encode(cards.map { (card) -> [String: [String: [String]]] in
                    let property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true)
                    return [
                        card.base.unitName: [
                            "ub": card.unionBurst!.actions.map { $0.parameter.localizedDetail(of: 95, property: property, style: .valueInCombat) },
                            "main_1": card.mainSkills[0].actions.map { $0.parameter.localizedDetail(of: 95, property: property, style: .valueInCombat) },
                            "main_2": card.mainSkills[1].actions.map { $0.parameter.localizedDetail(of: 95, property: property, style: .valueInCombat) },
                            "ex": card.exSkills[0].actions.map { $0.parameter.localizedDetail(of: 95, property: property, style: .valueInCombat) },
                            "ex+": card.exSkillEvolutions[0].actions.map { $0.parameter.localizedDetail(of: 95, property: property, style: .valueInCombat) },
                        ]
                    ]
                }) {
                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_skills_r9_95_ex.json"))
                }
                 */
                
                /*
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(cards.map {
                    [
                        $0.base.unitName: [
                            "ub": $0.unionBurst!.actions.map { $0.parameter.localizedDetail(of: 95, style: .full) },
                            "main_1": $0.mainSkills[0].actions.map { $0.parameter.localizedDetail(of: 95, style: .full) },
                            "main_2": $0.mainSkills[1].actions.map { $0.parameter.localizedDetail(of: 95, style: .full) },
                            "ex": $0.exSkills[0].actions.map { $0.parameter.localizedDetail(of: 95, style: .full) },
                            "ex+": $0.exSkillEvolutions[0].actions.map { $0.parameter.localizedDetail(of: 95, style: .full) },
                        ]
                    ]
                }) {
                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_skills_formula.json"))
                }
                 */
            }
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
            return sortedAndGroupedCards[section].title
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        ThemeManager.default.apply(theme: Theme.self, to: view) { (themeable, theme) in
            if let view = themeable as? UITableViewHeaderFooterView {
                view.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: theme.blurEffectStyle))
                view.textLabel?.textColor = theme.color.title
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedAndGroupedCards[section].cards.count
    }
    
    func cardOf(indexPath: IndexPath) -> Card {
        return sortedAndGroupedCards[indexPath.section].cards[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
        
        let card = cardOf(indexPath: indexPath)
        let (mode, text) = cardViewRightContent(card: card, settings: CardSortingViewController.Setting.default)
        cell.configure(for: card, value: text, mode: mode)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = sortedAndGroupedCards[indexPath.section].cards[indexPath.row]
        let vc = CDTabViewController(card: card)
        print("card id: \(card.base.unitId)")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cardViewRightContent(card: Card, settings: CardSortingViewController.Setting) -> (mode: CardView.Mode, text: String?) {
        let mode: CardView.Mode
        let text: String?
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

extension Array where Element == Card {
    
    mutating func sort(settings: CardSortingViewController.Setting) {

        let sortingMethod: (Card, Card) -> Bool
        switch settings.sortingMethod {
        case .atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate, .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery, .accuracy:
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
        case .combatEffectiveness:
            sortingMethod = { $0.combatEffectiveness() < $1.combatEffectiveness() }
        case .birthday:
            sortingMethod = { (Int($0.profile.birthMonth) ?? .max, Int($0.profile.birthDay) ?? .max) < (Int($1.profile.birthMonth) ?? .max, Int($1.profile.birthDay) ?? .max) }
        }
        
        sort(by: sortingMethod)
        
        if !settings.isAscending {
            reverse()
        }
    }
    
    func sorted(settings: CardSortingViewController.Setting) -> [Card] {
        var cards = self
        cards.sort(settings: settings)
        return cards
    }
    
    func filter(settings: CardSortingViewController.Setting) -> [CardTableViewController.Section] {
        
        typealias Section = CardTableViewController.Section

        var sections = [Section]()
        switch settings.groupingMethod {
        case .none:
            let section = Section(title: "default", cards: self)
            sections = [section]
        case .guild:
            var guildDict = [String: [Card]]()
            for card in self {
                if guildDict[card.profile.guild] == nil {
                    guildDict[card.profile.guild] = [Card]()
                }
                guildDict[card.profile.guild]?.append(card)
            }
            sections = guildDict.map { Section(title: $0, cards: $1) }.sorted { $0.title < $1.title }
        case .attackType:
            var physicsSection = Section(title: NSLocalizedString("Physics", comment: ""), cards: [])
            var magicSection = Section(title: NSLocalizedString("Magic", comment: ""), cards: [])

            for card in self {
                if card.base.atkType == 1 {
                    physicsSection.cards.append(card)
                } else {
                    magicSection.cards.append(card)
                }
            }
            sections = [physicsSection, magicSection]
        case .position:
            var frontSection = Section(title: NSLocalizedString("Vanguard", comment: ""), cards: [])
            var middleSection = Section(title: NSLocalizedString("Center", comment: ""), cards: [])
            var backSection = Section(title: NSLocalizedString("Back", comment: ""), cards: [])
            for card in self {
                if card.base.searchAreaWidth <= 300 {
                    frontSection.cards.append(card)
                } else if card.base.searchAreaWidth <= 600 {
                    middleSection.cards.append(card)
                } else {
                    backSection.cards.append(card)
                }
            }
            sections = [frontSection, middleSection, backSection]
        }
        
        for index in sections.indices {
            sections[index].cards.sort(settings: settings)
        }
        
        return sections
    }
}

extension Card {
    
    func iconID(style: CardSortingViewController.Setting.IconStyle = CardSortingViewController.Setting.default.iconStyle) -> Int {
        switch style {
        case .default:
            if base.rarity < 3 {
                return base.prefabId + 10
            } else {
                return base.prefabId + 30
            }
        case .r1:
            return base.prefabId + 10
        case .r3:
            return base.prefabId + 30
        }
    }
    
}
