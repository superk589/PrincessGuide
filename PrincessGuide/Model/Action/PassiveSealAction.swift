//
//  PassiveSealAction.swift
//  PrincessGuide
//
//  Created by zzk on 11/30/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class PassiveSealAction: ActionParameter {
    
    enum Timing: Int {
        case unknown = 0
        case buff = 1
    }
    
    enum TargetType: Int {
        case unknown = -1
        case source = 0
    }
    
    var timing: Timing {
        return Timing(rawValue: actionDetail1) ?? .unknown
    }
    
    var targetType: TargetType {
        return TargetType(rawValue: actionDetail3) ?? .unknown
    }
    
    var markDurationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue5), perLevel: String(actionValue6), key: nil, startIndex: 5)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch (timing, targetType) {
        case (.buff, .source):
            let format = NSLocalizedString("The caster gain a mark(ID: %@, max stacks %@, lasts for [%@]s) each time receives a buff, this effect lasts for [%@]s.", comment: "")
            return String(
                format: format,
                actionValue2.roundedString(roundingRule: nil),
                actionValue1.roundedString(roundingRule: nil),
                buildExpression(of: level, actionValues: markDurationValues, roundingRule: nil, style: style, property: property),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
