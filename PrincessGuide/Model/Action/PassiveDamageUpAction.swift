//
//  PassiveDamageUpAction.swift
//  PrincessGuide
//
//  Created by zzk on 11/30/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class PassiveDamageUpAction: ActionParameter {
    
    enum CountType: Int {
        case unknown = 0
        case debuff = 1
    }
    
    var countType: CountType {
        return CountType(rawValue: actionDetail1) ?? .unknown
    }
    
    enum EffectType: Int {
        case increase = 1
        case decrease
        
        var description: String {
            switch self {
            case .increase:
                return NSLocalizedString("Increase", comment: "")
            case .decrease:
                return NSLocalizedString("Decrease", comment: "")
            }
        }
    }
    
    var effectType: EffectType {
        return EffectType(rawValue: actionDetail2) ?? .increase
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
        
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch countType {
        case .debuff:
            let format = NSLocalizedString("%@ %@'s damage by [%@ * count of debuffs] times(up to %@ times of original damage), this effect lasts for [%@]s.", comment: "")
            return String(
                format: format,
                effectType.description,
                targetParameter.buildTargetClause(),
                actionValue1.roundedString(roundingRule: nil),
                actionValue2.roundedString(roundingRule: nil),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
