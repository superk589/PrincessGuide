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
    
    let isBossPart: Bool
    
    weak var owner: Enemy?
    
    init(base: Base, unit: Unit, isBossPart: Bool = false) {
        self.base = base
        self.unit = unit
        self.isBossPart = isBossPart
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
        
        var iconURL: URL {
            if visualChangeFlag == 1 {
                return URL.resource.appendingPathComponent("icon/unit_shadow/\(prefabId + 10).webp")
            } else {
                return URL.resource.appendingPathComponent("icon/unit/\(prefabId).webp")
            }
        }
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
        let spSkill1: Int
        let spSkill2: Int
        let spSkill3: Int
        let spSkill4: Int
        let spSkill5: Int
        let unionBurst: Int
        let unionBurstEvolution: Int
        let mainSkillEvolution1: Int
        let mainSkillEvolution2: Int
        
        let childEnemyParameter1: Int?
        let childEnemyParameter2: Int?
        let childEnemyParameter3: Int?
        let childEnemyParameter4: Int?
        let childEnemyParameter5: Int?

        let uniqueEquipmentFlag1: Int?
        let breakDurability: Int?
        let virtualHp: Int?
        
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
        
        var spSkillIDs: [Int] {
            return Array([spSkill1, spSkill2, spSkill3, spSkill4, spSkill5].prefix { $0 != 0 })
        }
        
        var exSkillLevels: [Int] {
            return [exSkillLv1, exSkillLv2, exSkillLv3, exSkillLv4, exSkillLv5]
        }
        
        var mainSkillLevels: [Int] {
            return [mainSkillLv1, mainSkillLv2, mainSkillLv3, mainSkillLv4, mainSkillLv5, mainSkillLv6, mainSkillLv7, mainSkillLv8, mainSkillLv9, mainSkillLv10]
        }
        
        var mainSkillEvolutionIDs: [Int] {
            return Array([mainSkillEvolution1, mainSkillEvolution2].prefix { $0 != 0 })
        }
        
        var partIDs: [Int] {
            return [
                childEnemyParameter1,
                childEnemyParameter2,
                childEnemyParameter3,
                childEnemyParameter4,
                childEnemyParameter5,
            ].compactMap { $0 }
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
        let levels: [Int]
        if let owner = self.owner, self.isBossPart {
            levels = owner.base.exSkillLevels
        } else {
            levels = base.exSkillLevels
        }
        return zip(levels, base.exSkillIDs)
//            .prefix { $0.0 != 0 }
            .reduce(into: [Int: Int]() ) {
                $0[$1.1] = $1.0
        }
    }()
    
    lazy var parts: [Enemy] = {
        let parts = base.partIDs.compactMap { id in
            DispatchSemaphore.sync { closure in
                Master.shared.getEnemies(enemyID: id, isBossPart: true, callback: closure)
            }
        }
        .flatMap { $0 }
        parts.forEach { $0.owner = self }
        return parts
    }()
    
    lazy var mainSkillLevels: [Int: Int] = {
        let levels: [Int]
        if let owner = self.owner, self.isBossPart {
            levels = owner.base.mainSkillLevels
        } else {
            levels = base.mainSkillLevels
        }
        return zip(levels, base.mainSkillIDs)
//            .prefix { $0.0 != 0 }
            .reduce(into: [Int: Int]()) {
                $0[$1.1] = $1.0
        }
    }()
    
    lazy var unionBurstSkillLevel: Int = {
        if let owner = self.owner, self.isBossPart {
            return owner.base.unionBurstLevel
        } else {
            return base.unionBurstLevel
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
    
    lazy var mainSkillEvolutions = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.mainSkillEvolutionIDs, callback: closure)
    } ?? []
    
    lazy var unionBurstEvolution = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: [self.base.unionBurstEvolution], callback: closure)
    }?.first
    
    lazy var spSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.spSkillIDs, callback: closure)
    } ?? []
}

extension Enemy {
    
    var hasUniqueEquipment: Bool {
        return base.uniqueEquipmentFlag1 == 1
    }
    
}
