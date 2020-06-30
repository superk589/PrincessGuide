//
//  AdditiveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AdditiveAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
        ]
    }
    
    var keyType: PropertyKey? {
        switch actionValue1 {
        case 7:
            return .atk
        case 8:
            return .magicStr
        case 9:
            return .def
        case 10:
            return .magicDef
        default:
            return nil
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("Modifier: add [%@ * HP] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        case 1:
            let format = NSLocalizedString("Modifier: add [%@ * lost HP] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        case 2:
            let format = NSLocalizedString("Modifier: add [%@ * count of defeated enemies] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        case 200..<300:
            let format = NSLocalizedString("Modifier: add [%@ * stacks of mark(ID: %d)] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), Int(actionValue1) % 200, actionDetail2, actionDetail1 % 10)
        case 4:
            let format = NSLocalizedString("Modifier: add [%@ * count of %@] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), targetParameter.buildTargetClause(), actionDetail2, actionDetail1 % 10)
        case 5:
            let format = NSLocalizedString("Modifier: add [%@ * count of damaged] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        case 6:
            let format = NSLocalizedString("Modifier: add [%@ * total damage] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        case 7...10:
            let format = NSLocalizedString("Modifier: add [%@ * %@ of %@] to value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), keyType?.description ?? NSLocalizedString("unknown property", comment: ""), targetParameter.buildTargetClause(), actionDetail2, actionDetail1 % 10)
        case 12:
            let format = NSLocalizedString("Modifier: add [%@ * count of %@ behind self] to value %d of effect %d.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true),
                targetParameter.buildTargetClause(),
                actionDetail2,
                actionDetail1 % 10
            )
        case 102:
            let format = NSLocalizedString("Modifier: add [%@ * count of omemes] value %d of effect %d.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), actionDetail2, actionDetail1 % 10)
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
