//
//  DamageCutAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2022/4/8.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class DamageCutAction: ActionParameter {
    
    enum DamageType: Int {
        case phisical = 1
        case magical
        case all
    }
    
    var damageType: DamageType {
        return DamageType(rawValue: actionDetail1) ?? .phisical
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch damageType {
        case .phisical:
            let format = NSLocalizedString("Reduce [%@]%% phisical damage taken by %@ for [%@]s.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: actionValues, roundingRule: nil, style: style, property: property),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case .magical:
            let format = NSLocalizedString("Reduce [%@]%% magical damage taken by %@ for [%@]s.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: actionValues, roundingRule: nil, style: style, property: property),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case .all:
            let format = NSLocalizedString("Reduce [%@]%% all damage taken by %@ for [%@]s.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: actionValues, roundingRule: nil, style: style, property: property),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
}
