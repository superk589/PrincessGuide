//
//  UniqueEquipment.swift
//  PrincessGuide
//
//  Created by zzk on 2018/11/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class UniqueEquipment: Codable {
    
    let atk: Int
    let craftFlg: Int
    let def: Int
    let description: String
    let dodge: Int
    let enableDonation: Int
    let energyRecoveryRate: Int
    let energyReduceRate: Int
    let equipmentEnhancePoint: Int
    let equipmentId: Int
    let equipmentName: String
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
    let requireLevel: Int
    let salePrice: Int
    let waveEnergyRecovery: Int
    let waveHpRecovery: Int
    let totalPoint: Int
    let accuracy: Int

    init(atk: Int, craftFlg: Int, def: Int, description: String, dodge: Int, enableDonation: Int, energyRecoveryRate: Int, energyReduceRate: Int, equipmentEnhancePoint: Int, equipmentId: Int, equipmentName: String, hp: Int, hpRecoveryRate: Int, lifeSteal: Int, magicCritical: Int, magicDef: Int, magicPenetrate: Int, magicStr: Int, physicalCritical: Int, physicalPenetrate: Int, promotionLevel: Int, requireLevel: Int, salePrice: Int, waveEnergyRecovery: Int, waveHpRecovery: Int, totalPoint: Int, accuracy: Int) {
        self.atk = atk
        self.craftFlg = craftFlg
        self.def = def
        self.description = description
        self.dodge = dodge
        self.enableDonation = enableDonation
        self.energyRecoveryRate = energyRecoveryRate
        self.energyReduceRate = energyReduceRate
        self.equipmentEnhancePoint = equipmentEnhancePoint
        self.equipmentId = equipmentId
        self.equipmentName = equipmentName
        self.hp = hp
        self.hpRecoveryRate = hpRecoveryRate
        self.lifeSteal = lifeSteal
        self.magicCritical = magicCritical
        self.magicDef = magicDef
        self.magicPenetrate = magicPenetrate
        self.magicStr = magicStr
        self.physicalCritical = physicalCritical
        self.physicalPenetrate = physicalPenetrate
        self.promotionLevel = promotionLevel
        self.requireLevel = requireLevel
        self.salePrice = salePrice
        self.waveEnergyRecovery = waveEnergyRecovery
        self.waveHpRecovery = waveHpRecovery
        self.totalPoint = totalPoint
        self.accuracy = accuracy
    }

    func enhanceCost(from: Int, to: Int = Preload.default.maxUniqueEquipmentLevel) -> Int {
        let costFrom = Preload.default.uniqueEquipmentEnhanceCost[from] ?? 0
        guard let costTo = Preload.default.uniqueEquipmentEnhanceCost[to] else {
            return 0
        }
        return costTo - costFrom
    }
    
    var enhanceCost: Int {
        return (Constant.presetManaCostPerPoint[promotionLevel] ?? 0) * totalPoint
    }

    lazy var craft: UniqueCraft? = {
        if craftFlg == 1 {
            return DispatchSemaphore.sync { (closure) in
                Master.shared.getUniqueCraft(equipmentID: equipmentId, callback: closure)
            }
        } else {
            return nil
        }
    }()

    lazy var recursiveConsumes: [UniqueCraft.Consume] = self.craft?.consumes ?? []
    
//
//    lazy var recursiveCraft: [Craft] = {
//        var crafts = [Craft]()
//        if let craft = craft {
//            crafts.append(craft)
//        }
//        for consume in craft?.consumes ?? [] {
//            if let equipment = consume.equipment {
//                crafts += equipment.recursiveCraft
//            }
//        }
//        return crafts
//    }()
//
    lazy var enhance: Enhance? = DispatchSemaphore.sync { (closure) in
        Master.shared.getUniqueEnhance(equipmentID: equipmentId, callback: closure)
    }

    func property(enhanceLevel: Int = Preload.default.maxUniqueEquipmentLevel) -> Property {
        var result = Property(atk: Double(atk), def: Double(def), dodge: Double(dodge),
                              energyRecoveryRate: Double(energyRecoveryRate), energyReduceRate: Double(energyReduceRate),
                              hp: Double(hp), hpRecoveryRate: Double(hpRecoveryRate), lifeSteal: Double(lifeSteal),
                              magicCritical: Double(magicCritical), magicDef: Double(magicDef),
                              magicPenetrate: Double(magicPenetrate), magicStr: Double(magicStr),
                              physicalCritical: Double(physicalCritical), physicalPenetrate: Double(physicalPenetrate),
                              waveEnergyRecovery: Double(waveEnergyRecovery), waveHpRecovery: Double(waveHpRecovery), accuracy: Double(accuracy))
        if let enhance = enhance {
            result += enhance.property * (enhanceLevel - 1)
        }
        return result
    }

    struct Enhance: Codable {
        let atk: Double
        let def: Double
        let description: String
        let dodge: Double
        let energyRecoveryRate: Double
        let energyReduceRate: Double
        let equipmentId: Int
        let equipmentName: String
        let hp: Double
        let hpRecoveryRate: Double
        let lifeSteal: Double
        let magicCritical: Double
        let magicDef: Double
        let magicPenetrate: Double
        let magicStr: Double
        let maxEquipmentEnhanceLevel: Int
        let physicalCritical: Double
        let physicalPenetrate: Double
        let promotionLevel: Int
        let waveEnergyRecovery: Double
        let waveHpRecovery: Double
        let accuracy: Double

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
}

extension UniqueEquipment {
    
    struct Cost {
        
    }
    
}
