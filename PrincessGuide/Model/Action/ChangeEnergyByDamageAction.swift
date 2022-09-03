//
//  ChangeEnergyByDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2022/9/3.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class ChangeEnergyByDamageAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionDetail1 {
        case 1:
            let format = NSLocalizedString("Add %@ mark stacks(max %@, ID: %d, lasts for [%@]s) to %@, restore [%@] TP and remove one stack when taking damage.", comment: "")
            return String(
                format: format,
                actionValue3.roundedString(roundingRule: nil),
                actionValue4.roundedString(roundingRule: nil),
                actionDetail2,
                actionValue5.roundedString(roundingRule: nil),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: actionValues, roundingRule: nil, style: style, property: property)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
