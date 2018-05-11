//
//  Enemy.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Enemy: Codable {

    let base: Base
    
    let unit: Unit
        
    init(base: Base, unit: Unit) {
        self.base = base
        self.unit = unit
    }
    
    struct Unit: Codable {
        let atkType: Int
        let comment: String
        let cutin: Int
        let motionType: Int
        let moveSpeed: Int
        let normalAtkCastTime: Double
        let prefabId: Int
        let seType: Int
        let searchAreaWidth: Int
        let unitId: Int
        let unitName: String
        let visualChangeFlag: Int
    }
    
    struct Base: Codable {
        let atk: Int
        let def: Int
        let dodge: Int
        let enemyId: Int
        let energyRecoveryRate: Int
        let energyReduceRate: Int
        let exSkillLv1: Int
        let exSkillLv2: Int
        let exSkillLv3: Int
        let exSkillLv4: Int
        let exSkillLv5: Int
        let hp: Int
        let hpRecoveryRate: Int
        let level: Int
        let lifeSteal: Int
        let magicCritical: Int
        let magicDef: Int
        let magicPenetrate: Int
        let magicStr: Int
        let mainSkillLv1: Int
        let mainSkillLv10: Int
        let mainSkillLv2: Int
        let mainSkillLv3: Int
        let mainSkillLv4: Int
        let mainSkillLv5: Int
        let mainSkillLv6: Int
        let mainSkillLv7: Int
        let mainSkillLv8: Int
        let mainSkillLv9: Int
        let name: String
        let physicalCritical: Int
        let physicalPenetrate: Int
        let promotionLevel: Int
        let rarity: Int
        let resistStatusId: Int
        let unionBurstLevel: Int
        let unitId: Int
        let waveEnergyRecovery: Int
        let waveHpRecovery: Int
        
        let exSkill1: Int
        let exSkill2: Int
        let exSkill3: Int
        let exSkill4: Int
        let exSkill5: Int
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
        let unionBurst: Int

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
    
    lazy var exSkill1: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: self.base.exSkill1, callback: closure)
    })
    
    lazy var mainSkill1: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill1, callback: closure)
    })
    
    lazy var mainSkill2: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill2, callback: closure)
    })
    
    lazy var mainSkill3: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill3, callback: closure)
    })
    
    lazy var mainSkill4: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill4, callback: closure)
    })
    
    lazy var mainSkill5: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill5, callback: closure)
    })
    
    lazy var mainSkill6: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill6, callback: closure)
    })
    
    lazy var mainSkill7: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill7, callback: closure)
    })
    
    lazy var mainSkill8: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill8, callback: closure)
    })
    
    lazy var mainSkill9: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill9, callback: closure)
    })
    
    lazy var mainSkill10: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.mainSkill10, callback: closure)
    })
    
    lazy var unionBurst: Skill? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getSkill(skillID: base.unionBurst, callback: closure)
    })
    
    lazy var patterns: [AttackPattern]? = DispatchSemaphore.sync({ [unowned self] closure in
        Master.shared.getAttackPatterns(unitID: base.unitId, callback: closure)
    })
    
}
