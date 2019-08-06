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
        return PercentModifier(Int(actionValue1))
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
        case atk = 1
        case def
        case magicStr
        case magicDef
        case dodge
        case physicalCritical
        case magicalCritical
        case energyRecoverRate
        case lifeSteal
        case moveSpeed
        case num
        case none
        
        var description: String {
            switch self {
            case .atk:
                return PropertyKey.atk.description
            case .def:
                return PropertyKey.def.description
            case .magicStr:
                return PropertyKey.magicStr.description
            case .magicDef:
                return PropertyKey.magicDef.description
            case .dodge:
                return PropertyKey.dodge.description
            case .physicalCritical:
                return PropertyKey.physicalCritical.description
            case .magicalCritical:
                return PropertyKey.magicCritical.description
            case .energyRecoverRate:
                return PropertyKey.energyRecoveryRate.description
            case .lifeSteal:
                return PropertyKey.lifeSteal.description
            case .moveSpeed:
                return NSLocalizedString("Move Speed", comment: "")
            case .num:
                return ""
            case .none:
                return ""
            }
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
    }
    
    var auraActionType: AuraActionType {
        return AuraActionType(actionDetail1)
    }
    
    var auraType: AuraType {
        return AuraType(rawValue: actionDetail1 / 10) ?? .none
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
