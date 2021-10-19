//
//  ChangeSpeedOverlapAction.swift
//  PrincessGuide
//
//  Created by zzk on 10/19/21.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

class ChangeSpeedOverlapAction: ActionParameter {
    
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
        switch speedChangeType {
        case .slow:
            let format = NSLocalizedString("Decrease %@ attack speed by [%@] times(stackable) for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: nil, style: style, property: property),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case .haste:
            let format = NSLocalizedString("Increase %@ attack speed by [%@] times(stackable) for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: nil, style: style, property: property),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
}
