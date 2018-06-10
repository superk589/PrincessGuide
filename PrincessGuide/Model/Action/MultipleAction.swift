//
//  MultipleAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class MultipleAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("Multiple [%@ * HP / max HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property))
        case 1:
            let format = NSLocalizedString("Multiple [%@ * lost HP / max HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property))
        case 2:
            let format = NSLocalizedString("Multiple [%@ * defeated enemy count] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
    override func buildExpression(of level: Int,
                                  actionValues: [ActionValue]? = nil,
                                  roundingRule: FloatingPointRoundingRule? = .down,
                                  style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle,
                                  property: Property = .zero,
                                  isHealing: Bool = false) -> String {
        let expression = super.buildExpression(of: level, actionValues: actionValues, roundingRule: roundingRule, style: style, property: property, isHealing: isHealing)
        if actionValue2 != 0 && actionValue3 != 0 {
            return "(\(expression))"
        } else {
            return expression
        }
    }
}
