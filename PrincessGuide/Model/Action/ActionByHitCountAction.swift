//
//  ActionByHitCountAction.swift
//  PrincessGuide
//
//  Created by zzk on 7/3/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class ActionByHitCountAction: ActionParameter {
    
    enum ConditionType: Int {
        case unknown = 0
        case damage = 1
        case target
        case hit
        case critical
    }
    
    var conditionType: ConditionType {
        return ConditionType(rawValue: actionDetail1) ?? .unknown
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let limitation: String
        if actionValue5 > 0 {
            let format = NSLocalizedString("(max %d times)", comment: "")
            limitation = String(format: format, actionValue5.roundedString(roundingRule: nil))
        } else {
            limitation = ""
        }
        switch conditionType {
        case .hit:
            let format = NSLocalizedString("Use %d%@ every %@ hits in next [%@]s.", comment: "")
            return String(
                format: format,
                actionDetail2 % 10,
                limitation,
                actionValue1.roundedString(roundingRule: nil),
                buildExpression(of: level, actionValues: durationValues, style: style)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
