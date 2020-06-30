//
//  SealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SealAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        if actionValue4 >= 0 {
            let format = NSLocalizedString("Add %@ mark stacks(max %@, ID: %@) on %@ for %@s.", comment: "")
            return String(format: format, actionValue4.roundedString(roundingRule: .down), actionValue1.roundedString(roundingRule: .down), actionValue2.roundedString(roundingRule: .down), targetParameter.buildTargetClause(), actionValue3.roundedString(roundingRule: nil))
        } else {
            let format = NSLocalizedString("Remove %@ mark stacks(ID: %@) on %@.", comment: "")
            return String(format: format, (-actionValue4).roundedString(roundingRule: .down), actionValue2.roundedString(roundingRule: .down), targetParameter.buildTargetClause())
        }
    }
}
