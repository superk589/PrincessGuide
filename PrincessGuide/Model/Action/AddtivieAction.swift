//
//  AddtivieAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AdditiveAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue2)),
            ActionValue(key: .skillLevel, value: String(actionValue3))
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("Add [%@ * HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property))
        case 1:
            let format = NSLocalizedString("Add [%@ * lost HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property))
        case 2:
            let format = NSLocalizedString("Add [%@ * defeated enemy count] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
    override func buildExpression(of level: Int,
                                  actionValues: [ActionValue]? = nil,
                                  roundingRule: FloatingPointRoundingRule? = .down,
                                  style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle,
                                  property: Property = .zero) -> String {
        let expression = super.buildExpression(of: level, actionValues: actionValues, roundingRule: roundingRule, style: style, property: property)
        if actionValue2 != 0 && actionValue3 != 0 {
            return "(\(expression))"
        } else {
            return expression
        }
    }
}
