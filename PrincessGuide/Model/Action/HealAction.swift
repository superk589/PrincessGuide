//
//  HealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class HealAction: ActionParameter {
    
    var healClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    var pecentModifier: PercentModifier {
        return PercentModifier(Int(actionValue1))
    }
    
    override var actionValues: [ActionValue] {
        switch healClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil),
                ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: .magicStr)
            ]
        case .physical:
            return [
                ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil),
                ActionValue(initial: String(actionValue4), perLevel: String(actionValue5), key: .atk)
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Restore %@ [%@]%@ HP.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), pecentModifier.description)
    }
    
}
