//
//  KnightGuardAction.swift
//  PrincessGuide
//
//  Created by zzk on 2/15/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class KnightGuardAction: ActionParameter {
    
    enum GuardType: Int {
        case physics = 1
        case magic
    }
    
    var guardType: GuardType {
        return GuardType(rawValue: Int(actionValue1)) ?? .physics
    }
    
    override var actionValues: [ActionValue] {
        switch guardType {
        case .magic:
            return [
                ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: .magicStr, startIndex: 4),
                ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
            ]
        case .physics:
            return [
                ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: .atk, startIndex: 4),
                ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
            ]
        }
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue6), perLevel: String(actionValue7), key: nil, startIndex: 6)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("When %@'s HP reaches 0, restore [%@] HP once in next [%@]s.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(anyOfModifier: true), buildExpression(of: level, style: style, property: property), buildExpression(of: level, actionValues: durationValues, style: style))
    }
}
