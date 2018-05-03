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
    
    init(base: Base, promotions: [Promotion], rarities: [Rarity], promotionStatuses: [PromotionStatus]) {
        self.base = base
        self.promotions = promotions
        self.promotionStatuses = promotionStatuses
        self.rarities = rarities
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
    }
    
    struct Promotion: Codable {
        let equipSlots: [Int]
        let promotionLevel: Int
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
    }
    
}

extension Card {

    var exSkill1: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.exSkill1, callback: closure)
        })
    }
    
    var exSkillEvolution1: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.exSkillEvolution1, callback: closure)
        })
    }
    
    var mainSkill1: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.mainSkill1, callback: closure)
        })
    }
    
    var mainSkill2: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.mainSkill2, callback: closure)
        })
    }
    
    var mainSkill3: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.mainSkill3, callback: closure)
        })
    }
    
    var unionBurst: Skill? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getSkill(skillID: base.unionBurst, callback: closure)
        })
    }
    
    var patterns: [AttackPattern]? {
        return DispatchSemaphore.sync({ closure in
            Master.shared.getAttackPatterns(unitID: base.unitId, callback: closure)
        })
    }
    
}
