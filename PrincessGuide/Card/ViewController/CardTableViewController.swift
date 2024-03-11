//
//  CardTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class CardTableViewController: UIViewController, DataChecking, UITableViewDelegate, UITableViewDataSource {
    
    var cards = [Card]()

    let refresher = RefreshHeader()
        
    struct Section {
        var title: String
        var cards: [Card]
    }
    
    var sections = [Section]()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd(_:)), name: .preloadEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilterChange(_:)), name: .cardSortingSettingsDidChange, object: nil)
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.check() }
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.description())
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableView.automaticDimension
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
            let sections = self?.createSections(settings: CardSortingViewController.Setting.default, cards: cards) ?? []
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.cards = cards
                self?.sections = sections
                self?.tableView.reloadData()
                    
                /* debug */
                /*let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(cards.map { [$0.base.unitName: $0.property()] }) {
                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_property.json"))
                }
                 */
                
                /*
                struct CardSkill: Codable {
                    var name: String
                    var skills: [String: [String]]
                }
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let settings = CDSettingsViewController.Setting.default
                let cardSkills = cards.map { (card) -> CardSkill in
                    let property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true)
                    return CardSkill(name: card.base.unitName, skills: [
                        "ub": card.unionBurst!.actions.map { $0.parameter.localizedDetail(of: 102, property: property, style: .valueInCombat) },
                        "main_1": card.mainSkills[0].actions.map { $0.parameter.localizedDetail(of: 102, property: property, style: .valueInCombat) },
                        "main_2": card.mainSkills[1].actions.map { $0.parameter.localizedDetail(of: 102, property: property, style: .valueInCombat) },
                        "ex": card.exSkills[0].actions.map { $0.parameter.localizedDetail(of: 102, property: property, style: .valueInCombat) },
                        "ex+": card.exSkillEvolutions[0].actions.map { $0.parameter.localizedDetail(of: 102, property: property, style: .valueInCombat) },
                        ])
                }
                
                if let data = try? encoder.encode(cardSkills) {
                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/card_skills.json"))
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
                

                
//                struct CardPropertyDiff: Codable {
//                    var name: String
//                    var properties: [Property.Item]
//                    var imageURL: URL
//                }
//                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
//                if let data = try? encoder.encode(cards.map {
//                    return CardPropertyDiff(name: $0.base.unitName, properties: ($0.property(unitRank: 12) - $0.property(unitRank: 11)).allProperties(), imageURL: URL.resource.appendingPathComponent("icon/unit/\($0.iconID()).webp"))
//                }) {
//                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/chara_r11_r10_diff.json"))
//                }

//                struct CardCombatEffectiveness: Codable {
//                    var name: String
//                    var properties: [String: Int]
//                    var imageURL: URL
//                }
//                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
//                if let data = try? encoder.encode(cards.map {
//                    return CardCombatEffectiveness(
//                        name: $0.base.unitName,
//                        properties: [
//                            "Star 5, Rank 11": $0.combatEffectiveness(),
//                            "Star 5, Rank 10": $0.combatEffectiveness(unitRank: 10),
//                            "Star 5, Rank 9": $0.combatEffectiveness(unitRank: 9),
//                            "Star 4, Rank 9": $0.combatEffectiveness(unitRank: 9, unitRarity: 4)
//                        ],
//                        imageURL: URL.resource.appendingPathComponent("icon/unit/\($0.iconID()).webp")
//                    )
//                }) {
//                    try? data.write(to: URL(fileURLWithPath: "/Users/zzk/Desktop/chara_r11_r10_r9_cf.json"))
//                }
                
            }
        }
    }
    
    @objc func handleFilterChange(_ notification: Notification) {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let strongSelf = self {
                let newSections = strongSelf.createSections(settings: CardSortingViewController.Setting.default, cards: strongSelf.cards)
                DispatchQueue.main.async {
                    LoadingHUDManager.default.hide()
                    self?.sections = newSections
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func handleUpdateEnd(_ notification: Notification) {
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.count <= 1 {
            return nil
        } else {
            return sections[section].title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cards.count
    }
    
    func cardOf(indexPath: IndexPath) -> Card {
        return sections[indexPath.section].cards[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.description(), for: indexPath) as! CardTableViewCell
        
        let card = cardOf(indexPath: indexPath)
        let (mode, text) = card.displayContent(for: CardSortingViewController.Setting.default)
        cell.configure(for: card, value: text, mode: mode)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = sections[indexPath.section].cards[indexPath.row]
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
        case .effectivePhysicalHPNoDodge:
            sortingMethod = { $0.property().effectivePhysicalHPNoDodge < $1.property().effectivePhysicalHPNoDodge }
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
    
    func grouped(settings: CardSortingViewController.Setting) -> [CardTableViewController.Section] {
        
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
        case .uniqueEquipNumber:
            sections = reduce(into: [Int: [Card]]()) {
                $0[$1.uniqueEquipIDs.count, default: [Card]()].append($1)
                }
                .map { Section(title: String($0.key), cards: $0.value) }
                .sorted { $0.title > $1.title }
        case .race:
            sections = reduce(into: [String: [Card]]()) {
                $0[$1.profile.race, default: [Card]()].append($1)
                }
                .map { Section(title: $0, cards: $1) }
                .sorted { $0.title < $1.title }
        case .cv:
            sections = reduce(into: [String: [Card]]()) {
                $0[$1.profile.voice, default: [Card]()].append($1)
                }
                .map { Section(title: $0, cards: $1) }
                .sorted { $0.title < $1.title }
        case .rarity6:
            sections = reduce(into: [String: [Card]]()) {
                $0[$1.hasRarity6 ? NSLocalizedString("Rarity 6", comment: "") : NSLocalizedString("Other", comment: ""), default: [Card]()].append($1)
                }
                .map { Section(title: $0, cards: $1) }
                .sorted { $0.title > $1.title }
        case .gachaType:
            sections = reduce(into: [String: [Card]]()) {
                $0[$1.base.isLimited == 1 ? NSLocalizedString("Limited Gacha", comment: "") : NSLocalizedString("Normal Gacha", comment: ""), default: [Card]()].append($1)
            }
            .map { Section(title: $0, cards: $1) }
            .sorted { ($0.cards.first?.base.isLimited ?? 0) > ($1.cards.first?.base.isLimited ?? 0) }
        case .talent:
            sections = reduce(into: [String: [Card]]()) {
                $0[CardTalent(rawValue: $1.base.talentId ?? 0)?.description ?? "", default: [Card]()].append($1)
            }
            .map { Section(title: $0, cards: $1) }
            .sorted { ($0.cards.first?.base.talentId ?? 0) < ($1.cards.first?.base.talentId ?? 0) }
        }
        
        return sections
    }
    
    mutating func filter(settings: CardSortingViewController.Setting) {
        self = self
            .filtered(by: settings.positionFilter)
            .filtered(by: settings.attackTypeFilter)
            .filtered(by: settings.hasRarity6Filter)
            .filtered(by: settings.hasUniqueEquipmentFilter)
            .filtered(by: settings.sourceFilter)
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
        case .highestRarity:
            if hasRarity6 {
                return base.prefabId + 60
            } else {
                return base.prefabId + 30
            }
        }
    }
    
    func iconURL(style: CardSortingViewController.Setting.IconStyle = CardSortingViewController.Setting.default.iconStyle) -> URL {
        let id = iconID(style: style)
        return URL.resource.appendingPathComponent("icon/unit/\(id).webp")
    }
}
