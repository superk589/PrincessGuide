//
//  Property.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum Property: CustomStringConvertible {
    
    case atk
    case atkGrowth
    case consumeGold
    case consumeNum
    case def
    case defGrowth
    case dodge
    case dodgeGrowth
    case energyRecoveryRate
    case energyRecoveryRateGrowth
    case energyReduceRate
    case energyReduceRateGrowth
    case hp
    case hpGrowth
    case hpRecoveryRate
    case hpRecoveryRateGrowth
    case lifeSteal
    case lifeStealGrowth
    case magicCritical
    case magicCriticalGrowth
    case magicDef
    case magicDefGrowth
    case magicPenetrate
    case magicPenetrateGrowth
    case magicStr
    case magicStrGrowth
    case physicalCritical
    case physicalCriticalGrowth
    case physicalPenetrate
    case physicalPenetrateGrowth
    case waveEnergyRecovery
    case waveEnergyRecoveryGrowth
    case waveHpRecovery
    case waveHpRecoveryGrowth
    
    var description: String {
        switch self {
        case .atk: return NSLocalizedString("ATK", comment: "")
        case .atkGrowth: return NSLocalizedString("ATK Growth", comment: "")
        case .consumeGold: return NSLocalizedString("Consume Gold", comment: "")
        case .consumeNum: return NSLocalizedString("Consume Num", comment: "")
        case .def: return NSLocalizedString("DEF", comment: "")
        case .defGrowth: return NSLocalizedString("DEF Growth", comment: "")
        case .dodge: return NSLocalizedString("Dodge", comment: "")
        case .dodgeGrowth: return NSLocalizedString("Dodge Growth", comment: "")
        case .energyRecoveryRate: return NSLocalizedString("Energy Recovery Rate", comment: "")
        case .energyRecoveryRateGrowth: return NSLocalizedString("Energy Recovery Rate Growth", comment: "")
        case .energyReduceRate: return NSLocalizedString("Energy Reduce Rate", comment: "")
        case .energyReduceRateGrowth: return NSLocalizedString("Energy Reduce Rate Growth", comment: "")
        case .hp: return NSLocalizedString("HP", comment: "")
        case .hpGrowth: return NSLocalizedString("HP Growth", comment: "")
        case .hpRecoveryRate: return NSLocalizedString("HP Recovery Rate", comment: "")
        case .hpRecoveryRateGrowth: return NSLocalizedString("HP Recovery Rate Growth", comment: "")
        case .lifeSteal: return NSLocalizedString("Life Steal", comment: "")
        case .lifeStealGrowth: return NSLocalizedString("Life Steal Growth", comment: "")
        case .magicCritical: return NSLocalizedString("Magic Critical", comment: "")
        case .magicCriticalGrowth: return NSLocalizedString("Magic Critical Growth", comment: "")
        case .magicDef: return NSLocalizedString("Magic DEF", comment: "")
        case .magicDefGrowth: return NSLocalizedString("Magic DEF Growth", comment: "")
        case .magicPenetrate: return NSLocalizedString("Magic Penetrate", comment: "")
        case .magicPenetrateGrowth: return NSLocalizedString("Magic Penetrate Growth", comment: "")
        case .magicStr: return NSLocalizedString("Magic STR", comment: "")
        case .magicStrGrowth: return NSLocalizedString("Magic STR Growth", comment: "")
        case .physicalCritical: return NSLocalizedString("Physical Critical", comment: "")
        case .physicalCriticalGrowth: return NSLocalizedString("Physical Critical Growth", comment: "")
        case .physicalPenetrate: return NSLocalizedString("Physical Penetrate", comment: "")
        case .physicalPenetrateGrowth: return NSLocalizedString("Physical Penetrate Growth", comment: "")
        case .waveEnergyRecovery: return NSLocalizedString("Wave Energy Recovery", comment: "")
        case .waveEnergyRecoveryGrowth: return NSLocalizedString("Wave Energy Recovery Growth", comment: "")
        case .waveHpRecovery: return NSLocalizedString("Wave HP Recovery", comment: "")
        case .waveHpRecoveryGrowth: return NSLocalizedString("Wave HP Recovery Growth", comment: "")
        }
    }
    
}
