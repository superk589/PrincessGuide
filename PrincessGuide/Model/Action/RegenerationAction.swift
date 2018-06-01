//
//  RegenerationAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class RegenerationAction: ActionParameter {
    
    var healClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        switch healClass {
        case .magical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case .physical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Restore %@ [%@] HP per second for %@s.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue5.description)
    }
}
