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
    
    override var actionValues: [ActionValue] {
        switch damageClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
            ]
        case .physical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
            ]
        case .inevitablePhysical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Deal [%@] %@ damage to %@.", comment: "")
        return String(format: format, buildExpression(of: level, style: style, property: property), damageClass.description, targetParameter.buildTargetClause())
    }
    
}
