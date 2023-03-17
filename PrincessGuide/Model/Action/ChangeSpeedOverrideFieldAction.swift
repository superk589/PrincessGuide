//
//  ChangeSpeedOverrideFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2023/3/17.
//  Copyright © 2023 zzk. All rights reserved.
//

import Foundation

class ChangeSpeedOverrideFieldAction: ActionParameter {
    
    enum SpeedChangeType: Int {
        case slow = 1
        case haste
    }
    
    var speedChangeType: SpeedChangeType {
        return SpeedChangeType(rawValue: actionDetail1) ?? .slow
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Summon a field of radius %d at position of %@ to multiple attack speed by [%@] for [%@]s.", comment: "")
        return String(
            format: format,
            Int(actionValue5),
            targetParameter.buildTargetClause(),
            buildExpression(of: level, roundingRule: nil, style: style, property: property),
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
}
