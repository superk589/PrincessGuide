//
//  AbnormalStateFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AbnormalStateFieldAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Summon a field of radius %d on %@ to cast effect %d for [%@]s.", comment: "")
        return String(
            format: format,
            Int(actionValue3),
            targetParameter.buildTargetClause(),
            actionDetail1 % 10,
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
}
