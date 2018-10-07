//
//  Property.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Property: Codable, Equatable {
    var atk: Double
    var def: Double
    var dodge: Double
    var energyRecoveryRate: Double
    var energyReduceRate: Double
    var hp: Double
    var hpRecoveryRate: Double
    var lifeSteal: Double
    var magicCritical: Double
    var magicDef: Double
    var magicPenetrate: Double
    var magicStr: Double
    var physicalCritical: Double
    var physicalPenetrate: Double
    var waveEnergyRecovery: Double
    var waveHpRecovery: Double
    var accuracy: Double
    
    var effectivePhysicalHP: Double {
        return hp * (1 + def / 100) * (1 + dodge / 100)
    }
    
    var effectiveMagicalHP: Double {
        return hp * (1 + magicDef / 100)
    }
    
    struct Item: Codable {
        var key: PropertyKey
        var value: Double
        
        func percent(selfLevel: Int = CDSettingsViewController.Setting.default.unitLevel,
                     targetLevel: Int = CDSettingsViewController.Setting.default.unitLevel) -> Double? {
            switch key {
            case .lifeSteal:
                return 100 * value / (100 + Double(targetLevel) + value)
            case .dodge:
                return 100 * value / (100 + value)
            case .magicDef:
                return 100 * value / (100 + value)
            case .def:
                return 100 * value / (100 + value) 
            case .physicalCritical, .magicCritical:
                return value * 0.05 * Double(selfLevel) / Double(targetLevel)
            default:
                return nil
            }
        }
        
        var hasLevelAssumption: Bool {
            switch key {
            case .physicalCritical, .magicCritical, .lifeSteal:
                return true
            default:
                return false
            }
        }
    }
    
    func keyPath(for key: PropertyKey) -> WritableKeyPath<Property, Double>? {
        switch key {
        case .atk:
            return \.atk
        case .def:
            return \.def
        case .dodge:
            return \.dodge
        case .energyRecoveryRate:
            return \.energyRecoveryRate
        case .energyReduceRate:
            return \.energyReduceRate
        case .hp:
            return \.hp
        case .hpRecoveryRate:
            return \.hpRecoveryRate
        case .lifeSteal:
            return \.lifeSteal
        case .magicCritical:
            return \.magicCritical
        case .magicDef:
            return \.magicDef
        case .magicPenetrate:
            return \.magicPenetrate
        case .magicStr:
            return \.magicStr
        case .physicalCritical:
            return \.physicalCritical
        case .physicalPenetrate:
            return \.physicalPenetrate
        case .waveEnergyRecovery:
            return \.waveEnergyRecovery
        case .waveHpRecovery:
            return \.waveHpRecovery
        case .accuracy:
            return \.accuracy
        case .unknown:
            return nil
        }
    }
    
    func item(for key: PropertyKey) -> Item {
        guard let keyPath = keyPath(for: key) else {
            return Item(key: .unknown, value: 0)
        }
        return Item(key: key, value: self[keyPath: keyPath])
    }
    
    func rounded() -> Property {
        var property = self
        PropertyKey.all.forEach {
            if let keyPath = property.keyPath(for: $0) {
                property[keyPath: keyPath] = self[keyPath: keyPath].rounded()
            }
        }
        return property
    }
    
    func ceiled() -> Property {
        var property = self
        PropertyKey.all.forEach {
            if let keyPath = property.keyPath(for: $0) {
                property[keyPath: keyPath] = ceil(self[keyPath: keyPath])
            }
        }
        return property
    }
    
    func noneZeroProperties() -> [Property.Item] {
        return allProperties().filter { $0.value != 0 }
    }
    
    func allProperties() -> [Property.Item] {
        return PropertyKey.all.compactMap { item(for: $0) }
    }
}

func + (lhs: Property, rhs: Property.Item) -> Property {
    var property = lhs
    if let keyPath = property.keyPath(for: rhs.key) {
        property[keyPath: keyPath] += rhs.value
        return property
    } else {
        return lhs
    }
}

func - (lhs: Property, rhs: Property.Item) -> Property {
    var property = lhs
    if let keyPath = property.keyPath(for: rhs.key) {
        property[keyPath: keyPath] -= rhs.value
        return property
    } else {
        return lhs
    }
}

func + (lhs: Property, rhs: Property) -> Property {
    var property = lhs
    PropertyKey.all.forEach {
        if let keyPath = property.keyPath(for: $0) {
            property[keyPath: keyPath] += rhs[keyPath: keyPath]
        }
    }
    return property
}

func - (lhs: Property, rhs: Property) -> Property {
    var property = lhs
    PropertyKey.all.forEach {
        if let keyPath = property.keyPath(for: $0) {
            property[keyPath: keyPath] -= rhs[keyPath: keyPath]
        }
    }
    return property
}

func += (lhs: inout Property, rhs: Property.Item) {
    if let keyPath = lhs.keyPath(for: rhs.key) {
        lhs[keyPath: keyPath] += rhs.value
    }
}

func += (lhs: inout Property, rhs: Property) {
    PropertyKey.all.forEach {
        if let keyPath = lhs.keyPath(for: $0) {
            lhs[keyPath: keyPath] += rhs[keyPath: keyPath]
        }
    }
}

func *= (lhs: inout Property, rhs: Double) {
    PropertyKey.all.forEach {
        if let keyPath = lhs.keyPath(for: $0) {
            lhs[keyPath: keyPath] *= rhs
        }
    }
}

func * (lhs: Property, rhs: Double) -> Property {
    var property = lhs
    PropertyKey.all.forEach {
        if let keyPath = property.keyPath(for: $0) {
            property[keyPath: keyPath] *= rhs
        }
    }
    return property
}

func *= (lhs: inout Property, rhs: Int) {
     lhs *= Double(rhs)
}

func * (lhs: Property, rhs: Int) -> Property {
    return lhs * Double(rhs)
}

extension Property {
    
    static let zero = Property()
    
    init() {
        atk = 0
        def = 0
        dodge = 0
        energyRecoveryRate = 0
        energyReduceRate = 0
        hp = 0
        hpRecoveryRate = 0
        lifeSteal = 0
        magicCritical = 0
        magicDef = 0
        magicPenetrate = 0
        magicStr = 0
        physicalCritical = 0
        physicalPenetrate = 0
        waveEnergyRecovery = 0
        waveHpRecovery = 0
        accuracy = 0
    }
}
