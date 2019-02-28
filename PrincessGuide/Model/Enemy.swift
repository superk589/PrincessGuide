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
        let accuracy: Int
        
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
                            waveEnergyRecovery: Double(waveEnergyRecovery), waveHpRecovery: Double(waveHpRecovery), accuracy: Double(accuracy))
        }
        
        var exSkillIDs: [Int] {
            return Array([exSkill1, exSkill2, exSkill3, exSkill4, exSkill5]
                //.prefix { $0 != 0 }
            )
        }
        
        var mainSkillIDs: [Int] {
            return Array([mainSkill1, mainSkill2, mainSkill3, mainSkill4, mainSkill5, mainSkill6, mainSkill7, mainSkill8, mainSkill9, mainSkill10]
                //.prefix { $0 != 0 }
            )
        }
        
        var exSkillLevels: [Int] {
            return [exSkillLv1, exSkillLv2, exSkillLv3, exSkillLv4, exSkillLv5]
        }
        
        var mainSkillLevels: [Int] {
            return [mainSkillLv1, mainSkillLv2, mainSkillLv3, mainSkillLv4, mainSkillLv5, mainSkillLv6, mainSkillLv7, mainSkillLv8, mainSkillLv9, mainSkillLv10]
        }
        
    }
    
    func exSkillLevel(for id: Int) -> Int {
        return exSkillLevels[id] ?? 0
    }
    
    func mainSkillLevel(for id: Int) -> Int {
        return mainSkillLevels[id] ?? 0
    }
    
    // MARK: lazy vars
    
    lazy var exSkillLevels: [Int: Int] = {
        return zip(base.exSkillLevels, base.exSkillIDs)
//            .prefix { $0.0 != 0 }
            .reduce(into: [Int: Int]() ) {
                $0[$1.1] = $1.0
        }
    }()
    
    lazy var mainSkillLevels: [Int: Int] = {
        return zip(base.mainSkillLevels, base.mainSkillIDs)
//            .prefix { $0.0 != 0 }
            .reduce(into: [Int: Int]()) {
                $0[$1.1] = $1.0
        }
    }()
    
    lazy var exSkills = DispatchSemaphore.sync { (closure) in
        Master.shared.getSkills(skillIDs: base.exSkillIDs, callback: closure)
    } ?? []
    
    lazy var mainSkills = DispatchSemaphore.sync { (closure) in
        Master.shared.getSkills(skillIDs: base.mainSkillIDs, callback: closure)
    } ?? []
    
    lazy var unionBurst = DispatchSemaphore.sync { (closure) in
        Master.shared.getSkills(skillIDs: [base.unionBurst], callback: closure)
    }?.first
    
    lazy var patterns: [AttackPattern]? = DispatchSemaphore.sync({ closure in
        Master.shared.getAttackPatterns(unitID: base.unitId, callback: closure)
    })
    
    lazy var resist: Resist? = DispatchSemaphore.sync { (closure) in
        Master.shared.getResistData(resistID: base.resistStatusId, callback: closure)
    }
}
