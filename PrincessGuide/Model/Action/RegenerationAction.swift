//
//  RegenerationAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class RegenerationAction: ActionParameter {
    
    var healClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    enum RegenerationType: Int, CustomStringConvertible {
        case hp = 1
        case tp = 2
        case unknown = -1
        var description: String {
            switch self {
            case .hp:
                return NSLocalizedString("HP", comment: "")
            case .tp:
                return NSLocalizedString("TP", comment: "")
            case .unknown:
                return NSLocalizedString("Unknown", comment: "")
            }
        }
    }
    
    var regenerationType: RegenerationType {
        return RegenerationType(rawValue: actionDetail2) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        switch healClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        case .physical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        default:
            return []
        }
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue5), perLevel: String(actionValue6), key: nil, startIndex: 5)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Restore %@ [%@] %@ per second for [%@]s.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), regenerationType.description, buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
    }
}
