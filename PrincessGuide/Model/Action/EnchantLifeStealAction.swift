//
//  EnchantLifeStealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class EnchantLifeStealAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
        ]
    }
    
    var stackValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        // FIXME: need more info for the meaning of action values
        return super.localizedDetail(of: level, property: property, style: style)
//        let format = NSLocalizedString("Add additional [%@] %@ to %@ for next [%@] attacks.", comment: "")
//        return String(format: format, buildExpression(of: level, style: style, property: property), PropertyKey.lifeSteal.description, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: stackValues, roundingRule: .down, style: style, property: property))

    }
}
