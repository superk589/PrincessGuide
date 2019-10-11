//
//  AweAction.swift
//  PrincessGuide
//
//  Created by zzk on 10/11/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class AweAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
        ]
    }
    
    var percentValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch aweType {
        case .ubAndSkill:
            let format = NSLocalizedString("Reduce [%@]%% damage or instant healing effect of union burst and main skills cast by %@ for [%@]s.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: percentValues, roundingRule: nil, style: style, property: property),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case .ubOnly:
            let format = NSLocalizedString("Reduce [%@]%% damage or instant healing effect of union burst cast by %@ for [%@]s.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: percentValues, roundingRule: nil, style: style, property: property),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case .unknown:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
    enum AweType: Int {
        case unknown = -1
        case ubOnly
        case ubAndSkill
    }
    
    var aweType: AweType {
        return AweType(rawValue: actionDetail1) ?? .unknown
    }
}
