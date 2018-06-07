//
//  AccumulativeDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AccumulativeDamageAction: ActionParameter {
 
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil)
        ]
    }
    
    var stackValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: nil)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Add additional [%@] damage per attack with max [%@] stacks to current target.", comment: "")
        return String(format: format, buildExpression(of: level, style: style, property: property), buildExpression(of: level, actionValues: stackValues, roundingRule: .down, style: style, property: property))
    }
    
}
