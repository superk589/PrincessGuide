//
//  FearAction.swift
//  PrincessGuide
//
//  Created by zzk on 8/31/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class FearAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1),
        ]
    }
    
    var chanceValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Fear %@ with [%@]%% chance for [%@]s.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property),
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
}
