//
//  IfForAllAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class IfForAllAction: ActionParameter {
        
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {

        switch actionDetail1 {
        case 0..<100:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 700:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: use %d if %@ is alone, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: use %d if %@ is alone.", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 700..<710:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: use %d if the count of %@(except stealth units) is %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 700, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: use %d if the count of %@(except stealth units) is %d.", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 700)
            } else if actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: use %d if the count of %@(except stealth units) is not %d.", comment: "")
                return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 700)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 720:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: use %d if among %@ exists unit(ID: %d), otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), Int(actionValue3), actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: use %d if among %@ exists unit(ID: %d).", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), Int(actionValue3))
            } else if actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: use %d if among %@ does not exist unit(ID: %d).", comment: "")
                return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), Int(actionValue3))
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 1000:
            let format = NSLocalizedString("Condition: if defeat target by the last effect then use %d.", comment: "")
            return String(format: format, actionDetail2 % 10)
        case 1200..<1300:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: counter is greater or equal to %d then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1 % 10, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: counter is greater or equal to %d then use %d.", comment: "")
                return String(format: format, actionDetail1 % 10, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
