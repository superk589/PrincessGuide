//
//  ChangeEnergyAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangeEnergyAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch actionDetail1 {
        case 1:
            let format = NSLocalizedString("Restore %@ [%@] TP.", comment: "")
            if targetParameter.targetType == .`self` {
                return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property, isSelfTPRestoring: true))
            } else {
                return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
            }
        default:
            let format = NSLocalizedString("Make %@ lose [%@] TP.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        }
    }
}
