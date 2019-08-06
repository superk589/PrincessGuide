//
//  ChangeParameterFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangeParameterFieldAction: AuraAction {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1),
        ]
    }
    
    override var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
        ]
    }
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        if targetParameter.targetType == .absolute {
            let format = NSLocalizedString("Summon a field of radius %d to %@ %@ [%@] %@ for [%@]s.", comment: "")
            return String(
                format: format,
                Int(actionValue5),
                auraActionType.description.lowercased(),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property),
                auraType.description,
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        } else {
            let format = NSLocalizedString("Summon a field of radius %d at position of %@ to %@ [%@] %@ for [%@]s.", comment: "")
            return String(
                format: format,
                Int(actionValue5),
                targetParameter.buildTargetClause(),
                auraActionType.description.lowercased(),
                buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property),
                auraType.description,
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
}
