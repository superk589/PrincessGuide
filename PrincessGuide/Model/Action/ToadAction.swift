//
//  ToadAction.swift
//  PrincessGuide
//
//  Created by zzk on 11/30/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class ToadAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Polymorph %@ for [%@]s.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
    }
}
