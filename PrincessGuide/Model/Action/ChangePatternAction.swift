//
//  ChangePatternAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangePatterAction: ActionParameter {
    
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        var result = ""
        
        switch actionDetail1 {
        case 1:
            if actionValue1 > 0 {
                let format = NSLocalizedString("Change attack pattern to %d for %@s.", comment: "")
                result = String(format: format, actionDetail2 % 10, actionValue1.roundedString(roundingRule: nil))
            } else {
                let format = NSLocalizedString("Change attack pattern to %d.", comment: "")
                result = String(format: format, actionDetail2 % 10, actionValue1.roundedString(roundingRule: nil))
            }
            if actionDetail3 == 1 {
                let clause = NSLocalizedString(" Can't use union burst when the new attack pattern is active.", comment: "")
                result.append(clause)
            }
        case 2:
            let format = NSLocalizedString("Change skill visual effect for %@s.", comment: "")
            result = String(format: format, actionValue1.roundedString(roundingRule: nil))
        default:
            result = super.localizedDetail(of: level, property: property, style: style)
        }
        
        return result
    }
}
