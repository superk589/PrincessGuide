//
//  PropertyKey.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum PropertyKey: CustomStringConvertible {
    
    case atk
    case def
    case dodge
    case energyRecoveryRate
    case energyReduceRate
    case hp
    case hpRecoveryRate
    case lifeSteal
    case magicCritical
    case magicDef
    case magicPenetrate
    case magicStr
    case physicalCritical
    case physicalPenetrate
    case waveEnergyRecovery
    case waveHpRecovery
    
    case unknown

    static let all = [PropertyKey.atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate,
                      .lifeSteal, .magicCritical, .magicDef, .magicPenetrate, .magicStr, .physicalCritical,
                      .physicalPenetrate, .waveEnergyRecovery, .waveHpRecovery]
    
    var description: String {
        switch self {
        case .atk: return NSLocalizedString("ATK", comment: "")
        case .def: return NSLocalizedString("DEF", comment: "")
        case .dodge: return NSLocalizedString("Dodge", comment: "")
        case .energyRecoveryRate: return NSLocalizedString("Energy Recovery Rate", comment: "")
        case .energyReduceRate: return NSLocalizedString("Energy Reduce Rate", comment: "")
        case .hp: return NSLocalizedString("HP", comment: "")
        case .hpRecoveryRate: return NSLocalizedString("HP Recovery Rate", comment: "")
        case .lifeSteal: return NSLocalizedString("Life Steal", comment: "")
        case .magicCritical: return NSLocalizedString("Magic Critical", comment: "")
        case .magicDef: return NSLocalizedString("Magic DEF", comment: "")
        case .magicPenetrate: return NSLocalizedString("Magic Penetrate", comment: "")
        case .magicStr: return NSLocalizedString("Magic STR", comment: "")
        case .physicalCritical: return NSLocalizedString("Physical Critical", comment: "")
        case .physicalPenetrate: return NSLocalizedString("Physical Penetrate", comment: "")
        case .waveEnergyRecovery: return NSLocalizedString("Wave Energy Recovery", comment: "")
        case .waveHpRecovery: return NSLocalizedString("Wave HP Recovery", comment: "")
        case .unknown: return NSLocalizedString("Unknown", comment: "")
        }
    }
    
}
