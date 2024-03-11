//
//  Card.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Card: Codable {
    
    static func findByID(_ id: Int) -> Card? {
        return Preload.default.cards[id]
    }
    
    let promotions: [Promotion]
    
    let rarities: [Rarity]
    
    let promotionStatuses: [PromotionStatus]

    let base: Base
    
    let profile: Profile
    
    let actualUnit: ActualUnit?
    
    let unitBackground: UnitBackground
    
    let comments: [Comment]
    
    let uniqueEquipIDs: [Int]
    
    let rarity6s: [Rarity6]
    
    let promotionBonuses: [PromotionBonus]
    
    init(base: Base, promotions: [Promotion], rarities: [Rarity], promotionStatuses: [PromotionStatus], profile: Profile, comments: [Comment], actualUnit: ActualUnit?, unitBackground: UnitBackground, uniqueEquipIDs: [Int], rarity6s: [Rarity6], promotionBonuses: [PromotionBonus]) {
        self.base = base
        self.promotions = promotions
        self.promotionStatuses = promotionStatuses
        self.rarities = rarities
        self.profile = profile
        self.comments = comments
        self.actualUnit = actualUnit
        self.unitBackground = unitBackground
        self.uniqueEquipIDs = uniqueEquipIDs
        self.rarity6s = rarity6s
        self.promotionBonuses = promotionBonuses
    }
    
    struct Base: Codable {
        
        let atkType: Int
        let comment: String
        let cutin1: Int
        let cutin2: Int
        let exSkill1: Int
        let exSkill2: Int
        let exSkill3: Int
        let exSkill4: Int
        let exSkill5: Int
        let exSkillEvolution1: Int
        let exSkillEvolution2: Int
        let exSkillEvolution3: Int
        let exSkillEvolution4: Int
        let exSkillEvolution5: Int
        let exskillDisplay: Int
        let guildId: Int
        let kana: String
        let mainSkill1: Int
        let mainSkill10: Int
        let mainSkill2: Int
        let mainSkill3: Int
        let mainSkill4: Int
        let mainSkill5: Int
        let mainSkill6: Int
        let mainSkill7: Int
        let mainSkill8: Int
        let mainSkill9: Int
        let motionType: Int
        let moveSpeed: Int
        let normalAtkCastTime: Double
        let prefabId: Int
        let rarity: Int
        let seType: Int
        let searchAreaWidth: Int
        let spSkill1: Int
        let spSkill2: Int
        let spSkill3: Int
        let spSkill4: Int
        let spSkill5: Int
        let unionBurst: Int
        let unitId: Int
        let unitName: String
        let unionBurstEvolution: Int
        let mainSkillEvolution1: Int
        let mainSkillEvolution2: Int
        let isLimited: Int
        let spSkillEvolution1: Int?
        let spSkillEvolution2: Int?
        let spUnionBurst: Int?
        let conversionId: Int?
        let talentId: Int?
        
        var rawName: String {
            if let substring = unitName.split(separator: "（").first {
                return String(substring)
            } else {
                return unitName
            }
        }
        
        var exSkillIDs: [Int] {
            return Array([exSkill1, exSkill2, exSkill3, exSkill4, exSkill5].prefix { $0 != 0 })
        }
        
        var exSkillEvolutionIDs: [Int] {
            return Array([exSkillEvolution1, exSkillEvolution2, exSkillEvolution3, exSkillEvolution4, exSkillEvolution5].prefix { $0 != 0 })
        }
        
        var mainSkillIDs: [Int] {
            return Array([mainSkill1, mainSkill2, mainSkill3, mainSkill4, mainSkill5].prefix { $0 != 0 })
        }
        
        var mainSkillEvolutionIDs: [Int] {
            return Array([mainSkillEvolution1, mainSkillEvolution2].prefix { $0 != 0 })
        }
 
        var spSkillIDs: [Int] {
            return Array([spSkill1, spSkill2, spSkill3, spSkill4, spSkill5].prefix { $0 != 0 })
        }
        
        var spSkillEvolutionIDs: [Int] {
            return Array([spSkillEvolution1, spSkillEvolution2].prefix { $0 != 0 }.compactMap { $0 })
        }
    
    }
    
    struct Profile: Codable {
        let age: String
        let birthDay: String
        let birthMonth: String
        let bloodType: String
        let catchCopy: String
        let favorite: String
        let guild: String
        let guildId: String
        let height: String
        let race: String
        let selfText: String
        let unitId: Int
        let unitName: String
        let voice: String
        let voiceId: Int
        let weight: String
        
        struct Item {
            var key: ItemKey
            var value: String
        }
        
        enum ItemKey: CustomStringConvertible {
            case height
            case weight
            case birthday
            case blood
            case race
            case guild
            case favorite
            case voice
            case age
            
            var description: String {
                switch self {
                case .height:
                    return NSLocalizedString("Height", comment: "")
                case .weight:
                    return NSLocalizedString("Weight", comment: "")
                case .birthday:
                    return NSLocalizedString("Birthday", comment: "")
                case .blood:
                    return NSLocalizedString("Blood Type", comment: "")
                case .race:
                    return NSLocalizedString("Race", comment: "")
                case .guild:
                    return NSLocalizedString("Guild", comment: "")
                case .favorite:
                    return NSLocalizedString("Interest", comment: "")
                case .voice:
                    return NSLocalizedString("CV", comment: "")
                case .age:
                    return NSLocalizedString("Age", comment: "")
                }
            }
        }
        
        var birthdayString: String {
            return String(format: NSLocalizedString("%@/%@", comment: ""), birthMonth, birthDay)
        }
        
        func item(for key: ItemKey) -> Item {
            switch key {
            case .height:
                return Item(key: key, value: height)
            case .weight:
                return Item(key: key, value: weight)
            case .birthday:
                return Item(key: key, value: birthdayString)
            case .blood:
                return Item(key: key, value: bloodType)
            case .race:
                return Item(key: key, value: race)
            case .guild:
                return Item(key: key, value: guild)
            case .favorite:
                return Item(key: key, value: favorite)
            case .voice:
                return Item(key: key, value: voice)
            case .age:
                return Item(key: key, value: age)
            }
        }
    }
    
    struct ActualUnit: Codable {
        let unitId: Int
        let unitName: String
        let bgId: Int
        let faceType: Int
    }
    
    struct UnitBackground: Codable {
        let unitId: Int
        let unitName: String
        let bgId: Int
        let position: Int
        let faceType: Int
        let bgName: String
    }
    
    struct Comment: Codable {
        let changeFace: Int
        let changeTime: Double
        let description: String
        let faceId: Int
        let id: Int
        let unitId: Int
        let useType: Int
        let voiceId: Int
    }
    
    class Promotion: Codable {
        let equipSlots: [Int]
        let promotionLevel: Int
        init(equipSlots: [Int], promotionLevel: Int) {
            self.equipSlots = equipSlots
            self.promotionLevel = promotionLevel
        }
        lazy var equipments: [Equipment] = self.equipSlots.compactMap { id in
            DispatchSemaphore.sync { (closure) in
                Master.shared.getEquipments(equipmentID: id, callback: closure)
            }?.first
        }
        
        lazy var equipmentsInSlot: [Equipment?] = self.equipSlots.map { id in
            DispatchSemaphore.sync { (closure) in
                Master.shared.getEquipments(equipmentID: id, callback: closure)
            }?.first
        }
        
        func countOf(_ equipment: Equipment) -> Int {
            return equipSlots.filter { $0 == equipment.equipmentId }.count
        }
    }
    
    func countOf(_ equipment: Equipment) -> Int {
        return promotions.reduce(0) { $0 + $1.countOf(equipment) }
    }
    
    func countOf(_ uniqueEquipment: UniqueEquipment) -> Int {
        return uniqueEquipIDs.filter { $0 == uniqueEquipment.equipmentId }.count
    }
    
    lazy var uniqueEquipments = DispatchSemaphore.sync { (closure) in
        return Master.shared.getUniqueEquipments(equipmentIDs: uniqueEquipIDs, callback: closure)
    } ?? []
    
    struct Rarity: Codable {
        
        let atk: Double
        let atkGrowth: Double
        let consumeGold: Int
        let consumeNum: Int
        let def: Double
        let defGrowth: Double
        let dodge: Double
        let dodgeGrowth: Double
        let energyRecoveryRate: Double
        let energyRecoveryRateGrowth: Double
        let energyReduceRate: Double
        let energyReduceRateGrowth: Double
        let hp: Double
        let hpGrowth: Double
        let hpRecoveryRate: Double
        let hpRecoveryRateGrowth: Double
        let lifeSteal: Double
        let lifeStealGrowth: Double
        let magicCritical: Double
        let magicCriticalGrowth: Double
        let magicDef: Double
        let magicDefGrowth: Double
        let magicPenetrate: Double
        let magicPenetrateGrowth: Double
        let magicStr: Double
        let magicStrGrowth: Double
        let physicalCritical: Double
        let physicalCriticalGrowth: Double
        let physicalPenetrate: Double
        let physicalPenetrateGrowth: Double
        let rarity: Int
        let unitMaterialId: Int
        let waveEnergyRecovery: Double
        let waveEnergyRecoveryGrowth: Double
        let waveHpRecovery: Double
        let waveHpRecoveryGrowth: Double
        let accuracy: Double
        let accuracyGrowth: Double

        var property: Property {
            return Property(atk: atk, def: def, dodge: dodge, energyRecoveryRate: energyRecoveryRate, energyReduceRate: energyReduceRate, hp: hp, hpRecoveryRate: hpRecoveryRate, lifeSteal: lifeSteal, magicCritical: magicCritical, magicDef: magicDef, magicPenetrate: magicPenetrate, magicStr: magicStr, physicalCritical: physicalCritical, physicalPenetrate: physicalPenetrate, waveEnergyRecovery: waveEnergyRecovery, waveHpRecovery: waveHpRecovery, accuracy: accuracy)
        }
        
        var propertyGrowth: Property {
            return Property(atk: atkGrowth, def: defGrowth, dodge: dodgeGrowth, energyRecoveryRate: energyRecoveryRateGrowth, energyReduceRate: energyReduceRateGrowth, hp: hpGrowth, hpRecoveryRate: hpRecoveryRateGrowth, lifeSteal: lifeStealGrowth, magicCritical: magicCriticalGrowth, magicDef: magicDefGrowth, magicPenetrate: magicPenetrateGrowth, magicStr: magicStrGrowth, physicalCritical: physicalCriticalGrowth, physicalPenetrate: physicalPenetrateGrowth, waveEnergyRecovery: waveEnergyRecoveryGrowth, waveHpRecovery: waveHpRecoveryGrowth, accuracy: accuracyGrowth)
        }
    }
    
    struct PromotionStatus: Codable {
        let atk: Int
        let def: Int
        let dodge: Int
        let energyRecoveryRate: Int
        let energyReduceRate: Int
        let hp: Int
        let hpRecoveryRate: Int
        let lifeSteal: Int
        let magicCritical: Int
        let magicDef: Int
        let magicPenetrate: Int
        let magicStr: Int
        let physicalCritical: Int
        let physicalPenetrate: Int
        let promotionLevel: Int
        let waveEnergyRecovery: Int
        let waveHpRecovery: Int
        let accuracy: Int
        
        var property: Property {
            return Property(atk: Double(atk), def: Double(def), dodge: Double(dodge),
                            energyRecoveryRate: Double(energyRecoveryRate), energyReduceRate: Double(energyReduceRate),
                            hp: Double(hp), hpRecoveryRate: Double(hpRecoveryRate), lifeSteal: Double(lifeSteal),
                            magicCritical: Double(magicCritical), magicDef: Double(magicDef),
                            magicPenetrate: Double(magicPenetrate), magicStr: Double(magicStr),
                            physicalCritical: Double(physicalCritical), physicalPenetrate: Double(physicalPenetrate),
                            waveEnergyRecovery: Double(waveEnergyRecovery), waveHpRecovery: Double(waveHpRecovery), accuracy: Double(accuracy))
        }
    }
    
    // MARK: lazy vars
    
    lazy var exSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.exSkillIDs, callback: closure)
    } ?? []
    
    lazy var exSkillEvolutions = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.exSkillEvolutionIDs, callback: closure)
    } ?? []
    
    lazy var mainSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.mainSkillIDs, callback: closure)
    } ?? []
    
    lazy var mainSkillEvolutions = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.mainSkillEvolutionIDs, callback: closure)
    } ?? []
    
    lazy var spUnionBurst = self.base.spUnionBurst.flatMap { id in
        DispatchSemaphore.sync { [unowned self] (closure) in
            Master.shared.getSkills(skillIDs: [id], callback: closure)
        }?.first
    }
    
    lazy var spSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.spSkillIDs, callback: closure)
    } ?? []
    
    lazy var spEvolutionsSkills = DispatchSemaphore.sync { [unowned self] closure in
        Master.shared.getSkills(skillIDs: self.base.spSkillEvolutionIDs, callback: closure)
    } ?? []
    
    lazy var unionBurst = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: [self.base.unionBurst], callback: closure)
    }?.first
    
    lazy var unionBurstEvolution = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: [self.base.unionBurstEvolution], callback: closure)
    }?.first
    
    lazy var patterns: [AttackPattern]? = DispatchSemaphore.sync { closure in
        Master.shared.getAttackPatterns(unitID: base.unitId, callback: closure)
    }
    
    lazy var charaStorys: [CharaStory]? = DispatchSemaphore.sync { (closure) in
        Master.shared.getCharaStory(charaID: charaID, callback: closure)
    }
    
    lazy var maxProperty: Property = property()
    
    lazy var stills = DispatchSemaphore.sync { (closure) in
        Master.shared.getStills(storyGroupID: charaID, callback: closure)
    } ?? []
    
    lazy var comics = DispatchSemaphore.sync { (closure) in
        Master.shared.getComics(unitID: base.unitId, callback: closure)
    } ?? []
    
    lazy var conversionUnit: Card? = self.base.conversionId.flatMap { id in
        DispatchSemaphore.sync { closure in
            Master.shared.getCards(cardID: id, originalID: base.unitId, callback: closure)
        }?.first
    }
}

extension Card {
    
    var charaID: Int {
        return base.unitId / 100
    }
    
    var maxEnergyReduceRank: Int? {
        promotionStatuses.enumerated()
            .max {
                let a = $0.element.property.energyReduceRate * 2 - (promotionStatuses[safe: $0.offset - 1]?.property.energyReduceRate ?? 0)
                let b = $1.element.property.energyReduceRate * 2 - (promotionStatuses[safe: $1.offset - 1]?.property.energyReduceRate ?? 0)
                return a < b
            }
            .flatMap { $0.offset + 1 }
    }
    
    var maxEnergyRecoveryRateRank: Int? {
        promotionStatuses.enumerated()
            .max {
                let a = $0.element.property.energyRecoveryRate * 2 - (promotionStatuses[safe: $0.offset - 1]?.property.energyRecoveryRate ?? 0)
                let b = $1.element.property.energyRecoveryRate * 2 - (promotionStatuses[safe: $1.offset - 1]?.property.energyRecoveryRate ?? 0)
                return a < b
            }
            .flatMap { $0.offset + 1 }
    }
    
    func property(unitLevel: Int = Preload.default.maxPlayerLevel,
                  unitRank: Int = Preload.default.maxEquipmentRank,
                  bondRank: Int = Constant.presetMaxPossibleBondRank,
                  unitRarity: Int = Constant.presetMaxPossibleRarity,
                  addsEx: Bool = CardSortingViewController.Setting.default.addsEx,
                  hasUniqueEquipment: Bool = CardSortingViewController.Setting.default.equipsUniqueEquipment,
                  uniqueEquipmentLevel: Int = Preload.default.maxUniqueEquipmentLevel) -> Property {
        var property = Property()
        let storyPropertyItems = charaStorys?.filter { $0.loveLevel <= bondRank }.flatMap { $0.status.map { $0.property() } } ?? []
        for item in storyPropertyItems {
            property += item
        }
        
        if unitRarity == 6 && hasRarity6 {
            if let rarity = rarities.first(where: { $0.rarity == 6 }) {
                property += rarity.property + rarity.propertyGrowth * Double(unitLevel + unitRank)
            }
        } else {
            if let rarity = rarities.sorted(by: { $0.rarity > $1.rarity }).first(where: { $0.rarity <= unitRarity }) {
                property += rarity.property + rarity.propertyGrowth * Double(unitLevel + unitRank)
            }
        }
        
        if let promotionStatus = promotionStatuses.first(where: { $0.promotionLevel == unitRank }) {
            property += promotionStatus.property
        }
        if let promotion = promotions.first(where: { $0.promotionLevel == unitRank }) {
            for equipment in promotion.equipments {
                property += equipment.property.ceiled()
            }
        }
        if hasUniqueEquipment {
            for equipment in uniqueEquipments {
                property += equipment.property(enhanceLevel: uniqueEquipmentLevel).ceiled()
            }
        }
        if addsEx && unitRank >= 7 {
            if unitRarity >= 5 {
                exSkillEvolutions
                    .flatMap { $0.actions }
                    .compactMap { ($0.parameter as? PassiveAction)?.propertyItem(of: unitLevel) }
                    .forEach { property += $0 }
            } else {
                exSkills
                    .flatMap { $0.actions }
                    .compactMap { ($0.parameter as? PassiveAction)?.propertyItem(of: unitLevel) }
                    .forEach { property += $0 }
            }
        }
        
        if let promotionBonus = promotionBonuses.first(where: { $0.promotionLevel == unitRank }) {
            property += promotionBonus.property
        }
        
        return property.rounded()
    }
    
    func combatEffectiveness(unitLevel: Int = Preload.default.maxPlayerLevel,
                             unitRank: Int = Preload.default.maxEquipmentRank,
                             bondRank: Int = Constant.presetMaxPossibleBondRank,
                             unitRarity: Int = Constant.presetMaxPossibleRarity,
                             skillLevel: Int = Preload.default.maxPlayerLevel,
                             hasUniqueEquipment: Bool = CardSortingViewController.Setting.default.equipsUniqueEquipment,
                             uniqueEquipmentLevel: Int = Preload.default.maxUniqueEquipmentLevel) -> Int {
        
        let property = self.property(unitLevel: unitLevel, unitRank: unitRank, bondRank: bondRank, unitRarity: unitRarity, addsEx: false, hasUniqueEquipment: hasUniqueEquipment, uniqueEquipmentLevel: uniqueEquipmentLevel)
        
        var result = 0.0
        
        let coefficient = Preload.default.coefficient
        
        PropertyKey.all.forEach {
            result += property.item(for: $0).value * coefficient.value(for: $0)
        }
        
        if hasUniqueEquipment {
            result += Double(mainSkillEvolutions.count * skillLevel) * coefficient.skill1EvolutionCoefficient * coefficient.skill1EvolutionSlvCoefficient
            if mainSkills.count > mainSkillEvolutions.count {
                result += Double((mainSkills.count - mainSkillEvolutions.count) * skillLevel) * coefficient.skillLvCoefficient
            }
            result += Double(uniqueEquipIDs.count) * 100
        } else {
            result += Double(mainSkills.count * skillLevel) * coefficient.skillLvCoefficient
        }
        
        if unionBurst != nil {
            if hasRarity6 && unionBurstEvolution != nil && unitRarity == 6 {
                result += (coefficient.ubEvolutionCoefficient + coefficient.ubEvolutionSlvCoefficient * Double(skillLevel)) * coefficient.skillLvCoefficient
            } else {
                result += Double(skillLevel) * coefficient.skillLvCoefficient
            }
        }
        
        if unitRank >= 7 {
            if unitRarity >= 5 {
                result += Double(exSkillEvolutions.count) * coefficient.exskillEvolutionCoefficient * coefficient.skillLvCoefficient
            }
            result += Double(exSkills.count * skillLevel) * coefficient.skillLvCoefficient
        }
    
        return Int(result.rounded())
    }
}

extension Card {
    
    func stillImageURLs(postfix: String = "") -> [URL] {
        return stills.map {
            URL.resource.appendingPathComponent("card/story/\($0.stillId).webp\(postfix)")
        }
    }
    
    func comicImageURLs(postfix: String = "") -> [URL] {
        return comics.map {
            URL.resource.appendingPathComponent("comic/\($0)_01.webp\(postfix)")
        }
    }
    
    func plateImageURLs(postfix: String = "") -> [URL] {
        var urls = [
            URL.resource.appendingPathComponent("icon/plate/\(base.prefabId + 10).webp\(postfix)"),
            URL.resource.appendingPathComponent("icon/plate/\(base.prefabId + 30).webp\(postfix)")
        ]
        if hasRarity6 {
            urls.append(URL.resource.appendingPathComponent("icon/plate/\(base.prefabId + 60).webp\(postfix)"))
        }
        return urls
    }
    
    func fullImageURL(postfix: String = "") -> [URL] {
        var urls = [URL.resource.appendingPathComponent("card/full/\(base.prefabId + 30).webp\(postfix)")]
        if hasRarity6 {
            urls.append(URL.resource.appendingPathComponent("card/full/\(base.prefabId + 60).webp\(postfix)"))
        }
        return urls
    }
    
    func profileImageURLs(postfix: String = "") -> [URL] {
        var urls = [
            URL.resource.appendingPathComponent("card/profile/\(base.prefabId + 10).webp\(postfix)"),
            URL.resource.appendingPathComponent("card/profile/\(base.prefabId + 30).webp\(postfix)")
        ]
        if hasRarity6 {
            urls.append(URL.resource.appendingPathComponent("card/profile/\(base.prefabId + 60).webp\(postfix)"))
        }
        if let actualUnitID = actualUnit?.unitId {
            urls.append(URL.resource.appendingPathComponent("card/actual_profile/\(actualUnitID).webp\(postfix)"))
        }
        return urls
    }
    
}

extension Card.Comment {
    var soundURL: URL {
        let format = "%03d"
        let id = String(format: format, voiceId)
        if unitId / 10 % 10 == 0 {
            return URL.resource.appendingPathComponent("sound/unit_common/\(unitId + 10)/vo_cmn_\(unitId + 10)_mypage_\(id).m4a")
        } else {
            return URL.resource.appendingPathComponent("sound/unit_common/\(unitId)/vo_cmn_\(unitId)_mypage_\(id).m4a")
        }
    }
}
