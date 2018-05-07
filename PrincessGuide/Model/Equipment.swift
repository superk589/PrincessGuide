//
//  Equipment.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class Equipment: Codable {
    
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
    
    init(atk: Int, craftFlg: Int, def: Int, description: String, dodge: Int, enableDonation: Int, energyRecoveryRate: Int, energyReduceRate: Int, equipmentEnhancePoint: Int, equipmentId: Int, equipmentName: String, hp: Int, hpRecoveryRate: Int, lifeSteal: Int, magicCritical: Int, magicDef: Int, magicPenetrate: Int, magicStr: Int, physicalCritical: Int, physicalPenetrate: Int, promotionLevel: Int, requireLevel: Int, salePrice: Int, waveEnergyRecovery: Int, waveHpRecovery: Int) {
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
    }
    
    lazy var craft: Craft? = {
        if craftFlg == 1 {
            return DispatchSemaphore.sync { (closure) in
                Master.shared.getCraft(equipmentID: equipmentId, callback: closure)
            }
        } else {
            return nil
        }
    }()
    
    lazy var recursiveConsumes: [Craft.Consume] = {
        var consumes = [Craft.Consume]()
        for consume in craft?.consumes ?? [] {
            if consume.equipment?.craftFlg == 0 {
                consumes += [consume]
            } else {
                consumes += consume.equipment?.recursiveConsumes ?? []
            }
        }
        return consumes
    }()
    
    lazy var enhance: Enhance? = DispatchSemaphore.sync { (closure) in
        Master.shared.getEnhance(equipmentID: equipmentId, callback: closure)
    }
    
    var property: Property {
        var result = Property(atk: Double(atk), def: Double(def), dodge: Double(dodge),
                        energyRecoveryRate: Double(energyRecoveryRate), energyReduceRate: Double(energyReduceRate),
                        hp: Double(hp), hpRecoveryRate: Double(hpRecoveryRate), lifeSteal: Double(lifeSteal),
                        magicCritical: Double(magicCritical), magicDef: Double(magicDef),
                        magicPenetrate: Double(magicPenetrate), magicStr: Double(magicStr),
                        physicalCritical: Double(physicalCritical), physicalPenetrate: Double(physicalPenetrate),
                        waveEnergyRecovery: Double(waveEnergyRecovery), waveHpRecovery: Double(waveHpRecovery))
        if let enhance = enhance {
            result += enhance.property * enhance.maxEquipmentEnhanceLevel
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
}

extension Equipment {
    
    private func mergeConsumes(_ consumes: [Craft.Consume], to another: [Craft.Consume]) -> [Craft.Consume] {
        var mergedConsumes = [Craft.Consume]()
        let ids = Set((consumes + another).map { $0.equipmentID })
        for id in ids {
            let num1 = consumes
                .filter { $0.equipmentID == id }
                .map { $0.consumeNum }
                .reduce(0, +)
            let num2 = another
                .filter { $0.equipmentID == id }
                .map { $0.consumeNum }
                .reduce(0, +)
            mergedConsumes.append(Craft.Consume(equipmentID: id, consumeNum: num1 + num2))
        }
        return mergedConsumes
    }
    
}

enum EquipmentType: Int, CustomStringConvertible {
    case dropped
    case crafted
    
    var description: String {
        switch self {
        case .dropped:
            return NSLocalizedString("Dropped", comment: "")
        default:
            return NSLocalizedString("Crafted", comment: "")
        }
    }
}
