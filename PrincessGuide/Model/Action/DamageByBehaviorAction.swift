//
//  DamageByBehaviorAction.swift
//  PrincessGuide
//
//  Created by zzk on 5/31/21.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

class DamageByBehaviorAction: ActionParameter {
    
    enum StateType: Int {
        case poison = 1
    }
    
    var stateType: StateType {
        return StateType(rawValue: actionDetail1) ?? .poison
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
        switch stateType {
        case .poison:
            let format = NSLocalizedString("Poison %@ and deal [%@] damage per second for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
}
