//
//  Card.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Card: Codable {
    
    let promotions: [Promotion]
    
    let rarities: [Rarity]
    
    let promotionStatuses: [PromotionStatus]

    let base: Base
    
    let profile: Profile
    
    let comments: [Comment]
    
    init(base: Base, promotions: [Promotion], rarities: [Rarity], promotionStatuses: [PromotionStatus], profile: Profile, comments: [Comment]) {
        self.base = base
        self.promotions = promotions
        self.promotionStatuses = promotionStatuses
        self.rarities = rarities
        self.profile = profile
        self.comments = comments
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
        
        var exSkillIDs: [Int] {
            return Array([exSkill1, exSkill2, exSkill3, exSkill4, exSkill5].prefix { $0 != 0 })
        }
        
        var exSkillEvolutionIDs: [Int] {
            return Array([exSkillEvolution1, exSkillEvolution2, exSkillEvolution3, exSkillEvolution4, exSkillEvolution5].prefix { $0 != 0 })
        }
        
        var mainSkillIDs: [Int] {
            return Array([mainSkill1, mainSkill2, mainSkill3, mainSkill4, mainSkill5].prefix { $0 != 0 })
        }
        
        var spSkillIDs: [Int] {
            return  Array([spSkill1, spSkill2, spSkill3, spSkill4, spSkill5].prefix { $0 != 0 })
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
                    return NSLocalizedString("Favorite", comment: "")
                case .voice:
                    return NSLocalizedString("CV", comment: "")
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
            }
        }
    }
    
    struct Comment: Codable {
        let changeFace: Int
        let changeTime: Int
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
    }
    
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

        var property: Property {
            return Property(atk: atk, def: def, dodge: dodge, energyRecoveryRate: energyRecoveryRate, energyReduceRate: energyReduceRate, hp: hp, hpRecoveryRate: hpRecoveryRate, lifeSteal: lifeSteal, magicCritical: magicCritical, magicDef: magicDef, magicPenetrate: magicPenetrate, magicStr: magicStr, physicalCritical: physicalCritical, physicalPenetrate: physicalPenetrate, waveEnergyRecovery: waveEnergyRecovery, waveHpRecovery: waveHpRecovery)
        }
        
        var propertyGrowth: Property {
            return Property(atk: atkGrowth, def: defGrowth, dodge: dodgeGrowth, energyRecoveryRate: energyRecoveryRateGrowth, energyReduceRate: energyReduceRateGrowth, hp: hpGrowth, hpRecoveryRate: hpRecoveryRateGrowth, lifeSteal: lifeStealGrowth, magicCritical: magicCriticalGrowth, magicDef: magicDefGrowth, magicPenetrate: magicPenetrateGrowth, magicStr: magicStrGrowth, physicalCritical: physicalCriticalGrowth, physicalPenetrate: physicalPenetrateGrowth, waveEnergyRecovery: waveEnergyRecoveryGrowth, waveHpRecovery: waveHpRecoveryGrowth)
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
        
        var property: Property {
            return Property(atk: Double(atk), def: Double(def), dodge: Double(dodge),
                            energyRecoveryRate: Double(energyRecoveryRate), energyReduceRate: Double(energyReduceRate),
                            hp: Double(hp), hpRecoveryRate: Double(hpRecoveryRate), lifeSteal: Double(lifeSteal),
                            magicCritical: Double(magicCritical), magicDef: Double(magicDef),
                            magicPenetrate: Double(magicPenetrate), magicStr: Double(magicStr),
                            physicalCritical: Double(physicalCritical), physicalPenetrate: Double(physicalPenetrate),
                            waveEnergyRecovery: Double(waveEnergyRecovery), waveHpRecovery: Double(waveHpRecovery))
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
    
    lazy var spSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.spSkillIDs, callback: closure)
    } ?? []
    
    lazy var unionBurst = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: [self.base.unionBurst], callback: closure)
    }?.first
    
    lazy var patterns: [AttackPattern]? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getAttackPatterns(unitID: base.unitId, callback: closure)
    })
    
    lazy var charaStorys: [CharaStory]? = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getCharaStory(charaID: charaID, callback: closure)
    }
    
    lazy var maxProperty: Property = property()
}

extension Card {
    
    var charaID: Int {
        return base.unitId / 100
    }
    
    func property(unitLevel: Int = ConsoleVariables.default.maxPlayerLevel,
                  unitRank: Int = ConsoleVariables.default.maxEquipmentRank,
                  loveRank: Int = Constant.presetMaxCharaLoveRank,
                  unitRarity: Int = Constant.presetMaxRarity) -> Property {
        var property = Property()
        let storyPropertyItems = charaStorys?.filter { $0.storyID % 1000 <= loveRank }.flatMap { $0.status.map { $0.property() } } ?? []
        for item in storyPropertyItems {
            property += item
        }
        if let rarity = rarities.first(where: { $0.rarity == unitRarity }) {
            property += rarity.property + rarity.propertyGrowth * Double(unitLevel + unitRank)
        }
        if let promotionStatus = promotionStatuses.first(where: { $0.promotionLevel == unitRank }) {
            property += promotionStatus.property
        }
        if let promotion = promotions.first(where: { $0.promotionLevel == unitRank }) {
            for equipment in promotion.equipments {
                property += equipment.property.ceiled()
            }
        }
        return property.rounded()
    }
    
}
