//
//  GiveValueAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2021/11/30.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

class GiveValueAction: ActionParameter {
    
    var format: String {
        return NSLocalizedString("Modifier: add %@ to value %d of effect %d.", comment: "")
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
        ]
    }
    
    var limitValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: nil, startIndex: 4)
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
    
    func buildFormulaString(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String? {
        var result = ""
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("[%@ * HP]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 1:
            let format = NSLocalizedString("[%@ * lost HP]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 2:
            let format = NSLocalizedString("[%@ * count of defeated enemies]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 200..<300:
            let format = NSLocalizedString("[%@ * stacks of mark(ID: %d)]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), Int(actionValue1) % 200)
        case 4:
            let format = NSLocalizedString("[%@ * count of %@]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), targetParameter.buildTargetClause())
        case 5:
            let format = NSLocalizedString("[%@ * count of damaged]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 6:
            let format = NSLocalizedString("[%@ * total damage]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 7...10:
            let format = NSLocalizedString("[%@ * %@ of %@]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), keyType?.description ?? NSLocalizedString("unknown property", comment: ""), targetParameter.buildTargetClause())
        case 12:
            let format = NSLocalizedString("[%@ * count of %@ behind self]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), targetParameter.buildTargetClause())
        case 13:
            let format = NSLocalizedString("[%@ * (lost HP / total HP) of %@]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), targetParameter.buildTargetClause())
        case 102:
            let format = NSLocalizedString("[%@ * count of omemes]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true))
        case 20..<30:
            let format = NSLocalizedString("[%@ * number on counter %d]", comment: "")
            result = String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property, hasBracesIfNeeded: true), Int(actionValue1) % 10)
        default:
            return nil
        }
        return result
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        var result = ""
        if let formula = buildFormulaString(of: level, property: property, style: style) {
            result = String(format: format, formula, actionDetail2, actionDetail1 % 10)
        } else {
            result = super.localizedDetail(of: level, property: property, style: style)
        }
        
        if actionValue4 != 0 || actionValue5 != 0 {
            let format = NSLocalizedString(" The upper limit of this effect is [%@].", comment: "")
            result += String(
                format: format,
                buildExpression(of: level, actionValues: limitValues, roundingRule: nil, style: style, property: property)
            )
        }
        return result
    }
    
}
