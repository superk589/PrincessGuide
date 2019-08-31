//
//  Minion.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Minion {
    
    typealias Rarity = Card.Rarity
    typealias Base = Card.Base
    
    let rarities: [Rarity]
    
    let base: Base
    
    init(base: Base, rarities: [Rarity]) {
        self.base = base
        self.rarities = rarities
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
    
    lazy var spSkills = DispatchSemaphore.sync { [unowned self] (closure) in
        Master.shared.getSkills(skillIDs: self.base.spSkillIDs, callback: closure)
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
    
    lazy var maxProperty: Property = property()
}

extension Minion {
    
    var charaID: Int {
        return base.unitId / 100
    }
    
    func property(unitLevel: Int = Preload.default.maxPlayerLevel,
                  unitRank: Int = Preload.default.maxEquipmentRank,
                  bondRank: Int = Constant.presetMaxPossibleBondRank,
                  unitRarity: Int = Constant.presetMaxPossibleRarity,
                  addsEx: Bool = CardSortingViewController.Setting.default.addsEx,
                  hasUniqueEquipment: Bool = CardSortingViewController.Setting.default.equipsUniqueEquipment,
                  uniqueEquipmentLevel: Int = Preload.default.maxUniqueEquipmentLevel) -> Property {
        var property = Property()
        if let rarity = rarities.first(where: { $0.rarity == unitRarity }) {
            property += rarity.property + rarity.propertyGrowth * Double(unitLevel + unitRank)
        }
        return property.rounded()
    }
    
}
