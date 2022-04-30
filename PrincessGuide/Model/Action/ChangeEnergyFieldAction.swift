//
//  ChangeEnergyFieldAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2022/4/30.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class ChangeEnergyFieldAction: ActionParameter {
   
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionDetail1 {
        case 1:
            let format = NSLocalizedString("Summon a field of radius %d at position of %@ to restore [%@] TP per second for [%@]s.", comment: "")
            return String(
                format: format,
                Int(actionValue5),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: .up, style: style, property: property, isSelfTPRestoring: targetParameter.targetType == .selfTarget),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        default:
            let format = NSLocalizedString("Summon a field of radius %d at position of %@ to lose [%@] TP per second for [%@]s.", comment: "")
            return String(
                format: format,
                Int(actionValue5),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: .up, style: style, property: property, isSelfTPRestoring: targetParameter.targetType == .selfTarget),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
    
}
