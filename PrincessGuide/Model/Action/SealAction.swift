//
//  SealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SealAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue4), perLevel: nil, key: nil, startIndex: 4)
        ]
    }
    
    var negativeActionValues: [ActionValue] {
        return [
            ActionValue(initial: String(-actionValue4), perLevel: nil, key: nil, startIndex: 4, negative: true)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        if actionValue4 >= 0 {
            let format = NSLocalizedString("Add %@ mark stacks(max %@, ID: %@) on %@ for %@s.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .down, style: style), actionValue1.roundedString(roundingRule: .down), actionValue2.roundedString(roundingRule: .down), targetParameter.buildTargetClause(), actionValue3.roundedString(roundingRule: nil))
        } else {
            let format = NSLocalizedString("Remove %@ mark stacks(ID: %@) on %@.", comment: "")
            return String(format: format, buildExpression(of: level, actionValues: negativeActionValues, roundingRule: .down, style: style), actionValue2.roundedString(roundingRule: .down), targetParameter.buildTargetClause())
        }
    }
}
