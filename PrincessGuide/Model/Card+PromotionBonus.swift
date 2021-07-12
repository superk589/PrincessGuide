//
//  Card+PromotionBonus.swift
//  PrincessGuide
//
//  Created by zzk on 7/12/21.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

extension Card {

    struct PromotionBonus: Codable {
        let unitId: Int
        let promotionLevel: Int
        let hp: Int
        let atk: Int
        let magicStr: Int
        let def: Int
        let magicDef: Int
        let physicalCritical: Int
        let magicCritical: Int
        let waveHpRecovery: Int
        let waveEnergyRecovery: Int
        let dodge: Int
        let physicalPenetrate: Int
        let magicPenetrate: Int
        let lifeSteal: Int
        let hpRecoveryRate: Int
        let energyRecoveryRate: Int
        let energyReduceRate: Int
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
}
