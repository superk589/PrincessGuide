//
//  AuraAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AuraAction: ActionParameter {
    
    var percentModifier: PercentModifier {
        switch auraType {
        case .receivedCriticalDamage:
            return .percent
        default:
            return PercentModifier(Int(actionValue1))
        }
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: nil, startIndex: 4)
        ]
    }
    
    enum AuraType: Int, CustomStringConvertible {
        case none = -1
        case atk = 1
        case def
        case magicStr
        case magicDef
        case dodge
        case physicalCritical
        case magicalCritical
        case energyRecoverRate
        case lifeSteal
        case moveSpeed = 10
        case physicalCriticalDamage
        case magicalCriticalDamage
        case accuracy
        case receivedCriticalDamage
        case maxHP = 100
        
        var description: String {
            let result: String
            switch self {
            case .atk:
                result = PropertyKey.atk.description
            case .def:
                result = PropertyKey.def.description
            case .magicStr:
                result = PropertyKey.magicStr.description
            case .magicDef:
                result = PropertyKey.magicDef.description
            case .dodge:
                result = PropertyKey.dodge.description
            case .physicalCritical:
                result = PropertyKey.physicalCritical.description
            case .magicalCritical:
                result = PropertyKey.magicCritical.description
            case .energyRecoverRate:
                result = PropertyKey.energyRecoveryRate.description
            case .lifeSteal:
                result = PropertyKey.lifeSteal.description
            case .moveSpeed:
                result = NSLocalizedString("Move Speed", comment: "")
            case .accuracy:
                result = PropertyKey.accuracy.description
            case .none:
                result = ""
            case .physicalCriticalDamage:
                result = NSLocalizedString("Physical Critical Damage", comment: "")
            case .magicalCriticalDamage:
                result = NSLocalizedString("Magical Critical Damage", comment: "")
            case .maxHP:
                return NSLocalizedString("Max. HP", comment: "")
            case .receivedCriticalDamage:
                return NSLocalizedString("Received Critical Damage", comment: "")
            }
            return result
        }
    }
    
    enum AuraActionType {
        
        case raise
        case reduce
        
        var description: String {
            switch self {
            case .raise:
                return NSLocalizedString("Raise", comment: "")
            case .reduce:
                return NSLocalizedString("Reduce", comment: "")
            }
        }
        
        init(_ value: Int) {
            if value % 10 == 1 {
                self = .reduce
            } else {
                self = .raise
            }
        }
        
        mutating func toggle() {
            switch self {
            case .raise:
                self = .reduce
            case .reduce:
                self = .raise
            }
        }
    }
    
    var auraActionType: AuraActionType {
        var type = AuraActionType(actionDetail1)
        if auraType == .receivedCriticalDamage {
            type.toggle()
        }
        return type
    }
    
    var auraType: AuraType {
        if actionDetail1 == 1 {
            return .maxHP
        } else {
            return AuraType(rawValue: actionDetail1 / 10) ?? .none
        }
    }
    
    enum BreakType: Int {
        case unknown = -1
        case normal = 1
        case `break`
    }
    
    var breakType: BreakType {
        return BreakType(rawValue: actionDetail2) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch breakType {
        case .break:
            let format = NSLocalizedString("%@ %@ [%@]%@ %@ during break.", comment: "")
            return String(format: format, auraActionType.description, targetParameter.buildTargetClause(), buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property), percentModifier.description, auraType.description)
        default:
            let format = NSLocalizedString("%@ %@ [%@]%@ %@ for [%@]s.", comment: "")
            return String(format: format, auraActionType.description, targetParameter.buildTargetClause(), buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property), percentModifier.description, auraType.description, buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
        }
    }
}
