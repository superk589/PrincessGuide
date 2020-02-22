//
//  LogBarrierAction.swift
//  PrincessGuide
//
//  Created by zzk on 2/22/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class LogBarrierAction: ActionParameter {
    
    enum BarrierType: Int {
        case physics = 1
        case magic
        case all
    }
    
    var barrierType: BarrierType {
        return BarrierType(rawValue: Int(actionValue1)) ?? .all
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
        let format = NSLocalizedString("Cast a barrier on %@ to reduce damage over %@ with coefficient [%@](the greater the less reduced amount) for [%@]s.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            actionValue5.roundedString(roundingRule: nil),
            buildExpression(of: level, roundingRule: nil, style: style),
            buildExpression(of: level, actionValues: durationValues, style: style)
        )
    }
}
