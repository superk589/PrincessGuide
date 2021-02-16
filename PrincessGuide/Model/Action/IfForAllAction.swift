//
//  IfForAllAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class IfForAllAction: ActionParameter {
    
    var trueClause: String? {
        
        guard actionDetail2 != 0 else {
            return nil
        }
        
        switch actionDetail1 {
        case 710, 100:
            if let ifType = IfType(rawValue: actionDetail1) {
                let format = NSLocalizedString("use %d to %@ if %@", comment: "")
                return String(format: format, actionDetail2 % 100, targetParameter.buildTargetClause(anyOfModifier: true), ifType.description)
            } else {
                return nil
            }
        case 0..<100:
            let format = NSLocalizedString("%d%% chance use %d", comment: "")
            return String(format: format, actionDetail1, actionDetail2 % 10)
        case 599:
            let format = NSLocalizedString("use %d if %@ has any dot debuff", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 600..<700 where actionValue3 == 0:
            let format = NSLocalizedString("use %d if %@ is in state of ID: %d", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
        case 600..<700:
            let format = NSLocalizedString("use %d if %@ is in state of ID: %d with stacks greater than or equal to %d", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600, Int(actionValue3))
        case 700:
            let format = NSLocalizedString("use %d if %@ is alone", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 700..<710:
            let format = NSLocalizedString("use %d if the count of %@(except stealth units) is %d", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 700)
        case 720:
            let format = NSLocalizedString("use %d if among %@ exists unit(ID: %d)", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), Int(actionValue3))
        case 901..<1000:
            let format = NSLocalizedString("use %d if %@'s HP is below %d%%", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(anyOfModifier: true), actionDetail1 - 900)
        case 1000:
            let format = NSLocalizedString("if target is defeated by the last effect then use %d", comment: "")
            return String(format: format, actionDetail2 % 10)
        case 1001:
            let format = NSLocalizedString("use %d if this skill is critical", comment: "")
            return String(format: format, actionDetail2 % 10)
        case 1200..<1300:
            let format = NSLocalizedString("counter %d is greater than or equal to %d then use %d", comment: "")
            return String(format: format, actionDetail1 % 100 / 10, actionDetail1 % 10, actionDetail2 % 10)
        default:
            return nil
        }
    }
    
    var falseClause: String? {
        
        guard actionDetail3 != 0 else {
            return nil
        }
        
        switch actionDetail1 {
        case 710:
            if let ifType = IfType(rawValue: actionDetail1) {
                let format = NSLocalizedString("use %d to %@ if not %@", comment: "")
                return String(format: format, actionDetail3 % 100, targetParameter.buildTargetClause(anyOfModifier: true), ifType.description)
            } else {
                return nil
            }
        case 0..<100:
            let format = NSLocalizedString("%d%% chance use %d", comment: "")
            return String(format: format, (100 - actionDetail1), actionDetail3 % 10)
        case 599:
            let format = NSLocalizedString("use %d if %@ has no dot debuff", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 600..<700 where actionValue3 == 0:
            let format = NSLocalizedString("use %d if %@ is not in state of ID: %d", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
        case 600..<700:
            let format = NSLocalizedString("use %d if %@ is not in state of ID: %d with stacks greater than or equal to %d", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600, Int(actionValue3))
        case 700:
            let format = NSLocalizedString("use %d if %@ is not alone", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 700..<710:
            let format = NSLocalizedString("use %d if the count of %@(except stealth units) is not %d", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 700)
        case 720:
            let format = NSLocalizedString("use %d if among %@ does not exist unit(ID: %d)", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), Int(actionValue3))
        case 901..<1000:
            let format = NSLocalizedString("use %d if %@'s HP is not below %d%%", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(anyOfModifier: true), actionDetail1 - 900)
        case 1000:
            let format = NSLocalizedString("if target is not defeated by last effect then use %d", comment: "")
            return String(format: format, actionDetail3 % 10)
        case 1001:
            let format = NSLocalizedString("use %d if this skill is not critical", comment: "")
            return String(format: format, actionDetail3 % 10)
        case 1200..<1300:
            let format = NSLocalizedString("counter %d is less than %d then use %d", comment: "")
            return String(format: format, actionDetail1 % 100 / 10, actionDetail1 % 10, actionDetail3 % 10)
        default:
            return nil
        }
    }
        
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {

        let format = NSLocalizedString("Exclusive condition: %@.", comment: "")
        if trueClause == nil && falseClause == nil {
            return super.localizedDetail(of: level, property: property, style: style)
        } else {
            return String(format: format, [trueClause, falseClause].compactMap { $0 }.joined(separator: NSLocalizedString(", ", comment: "clause separator")))
        }
    }
    
}
