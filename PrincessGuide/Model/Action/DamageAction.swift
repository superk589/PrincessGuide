//
//  DamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class DamageAction: ActionParameter {
    
    var damageClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    var criticalModifier: CriticalModifier {
        return CriticalModifier(rawValue: Int(actionValue5)) ?? .normal
    }
    
    override var actionValues: [ActionValue] {
        switch damageClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        case .physical, .inevitablePhysical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch criticalModifier {
        case .normal:
            let format = NSLocalizedString("Deal [%@] %@ damage to %@.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property), damageClass.description, targetParameter.buildTargetClause())
        case .critical:
            let format = NSLocalizedString("Deal [%@] %@ damage to %@, and this attack is ensured critical.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property), damageClass.description, targetParameter.buildTargetClause())
        }
    }
    
}
