//
//  Chara.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

extension Chara {
    
    var card: Card? {
        return Card.findByID(Int(id))
    }
    
    var iconID: Int? {
        if rarity >= 3 {
            return card?.iconID(style: .r3)
        } else {
            return card?.iconID(style: .r1)
        }
    }
    
    convenience init(anotherChara: Chara, context: NSManagedObjectContext) {
        self.init(context: context)
        bondRank = anotherChara.bondRank
        level = anotherChara.level
        rank = anotherChara.rank
        skillLevel = anotherChara.skillLevel
        slot1 = anotherChara.slot1
        slot2 = anotherChara.slot2
        slot3 = anotherChara.slot3
        slot4 = anotherChara.slot4
        slot5 = anotherChara.slot5
        slot6 = anotherChara.slot6
        modifiedAt = Date()
        id = anotherChara.id
        rarity = anotherChara.rarity
        enablesUniqueEquipment = anotherChara.enablesUniqueEquipment
        uniqueEquipmentLevel = anotherChara.uniqueEquipmentLevel
    }

    func unequiped() -> [Equipment] {
        var array = [Equipment]()
        if let promotions = card?.promotions, promotions.count >= rank {
            let currentPromotion = promotions[Int(rank - 1)]
            let higherPromotions = promotions[Int(rank)..<promotions.count]
            
            array += currentPromotion.equipmentsInSlot.enumerated().compactMap { (offset, element) -> Equipment? in
                if slots[safe: offset] ?? false {
                    return nil
                } else {
                    return element
                }
            }
            
            array += higherPromotions.flatMap {
                $0.equipmentsInSlot.compactMap { $0 }
            }
        }
        return array
    }
    
    func maxRankUnequiped() -> [Equipment] {
        
        if let promotions = card?.promotions {
            if promotions.count == rank {
                return unequiped()
            } else {
                var array = [Equipment]()
                if let highestPromotion = promotions.last {
                    array += highestPromotion.equipmentsInSlot.compactMap { $0 }
                }
                return array
            }
        } else {
            return []
        }
    }
    
    func uniqueUnequiped() -> [UniqueEquipment] {
        if self.enablesUniqueEquipment {
            return []
        } else {
            return self.card?.uniqueEquipments ?? []
        }
    }
    
    var uniqueEquipmentEnhanceCost: Int {
        let cost = self.card?.uniqueEquipments.map { $0.enhanceCost(from: Int(uniqueEquipmentLevel)) }.reduce(0, +)
        return cost ?? 0
    }
    
    var slots: [Bool] {
        get {
            return [slot1, slot2, slot3, slot4, slot5, slot6]
        }
        
        set {
            guard newValue.count == 6 else {
                return
            }
            slot1 = newValue[0]
            slot2 = newValue[1]
            slot3 = newValue[2]
            slot4 = newValue[3]
            slot5 = newValue[4]
            slot6 = newValue[5]
        }
    }
    
    var skillLevelUpCost: Int {
        let level = Int(skillLevel)
        let targetLevel = Preload.default.maxPlayerLevel
        
        guard level < targetLevel else {
            return 0
        }
        
        var cost = 0
        for key in (level + 1)...targetLevel {
            let value = Preload.default.skillCost[key] ?? 0
            cost += value
        }
        return cost * Constant.presetNeededToLevelUpSkillCount
    }
    
    var experienceToMaxLevel: Int {
        let level = Int(self.level)
        let targetLevel = Preload.default.maxPlayerLevel
        guard level < targetLevel else {
            return 0
        }
        
        let targetExperience = Preload.default.unitExperience[targetLevel] ?? 0
        let currentExperience = Preload.default.unitExperience[level] ?? 0
        return targetExperience - currentExperience
    }
}

extension Card.Promotion {
    
    var defaultSlots: [Bool] {
        return equipSlots.map {
            $0 != 999999
        }
    }
    
}
