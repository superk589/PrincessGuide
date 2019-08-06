//
//  NoDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class NoDamageAction: ActionParameter {
    
    enum NoDamageType: Int {
        case unknown = 0
        case noDamage = 1
        case dodgePhysics
        case dodgeAll
        case abnormal
        case debuff
    }
    
    var noDamageType: NoDamageType {
        return NoDamageType(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch noDamageType {
        case .noDamage:
            let format = NSLocalizedString("Become invulnerable for [%@]s.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property))
        case .dodgePhysics:
            let format = NSLocalizedString("Become invulnerable to physical damage for [%@]s.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
