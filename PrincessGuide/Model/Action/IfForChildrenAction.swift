//
//  IfForChildrenAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class IfForChildrenAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch actionDetail1 {
        case 100:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: if target is controlled then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: if target is controlled then use %d.", comment: "")
                return String(format: format, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 200:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: if target is blinded then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: if target is blinded then use %d.", comment: "")
                return String(format: format, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 300:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: if target is charmed then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: if target is charmed then use %d.", comment: "")
                return String(format: format, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        case 500:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: if target is burned then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: if target is burned then use %d.", comment: "")
                return String(format: format, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
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
        case 901..<1000:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Condition: if target's HP is below %d%% then use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1 % 100, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Condition: if target's HP is below %d%% then use %d.", comment: "")
                return String(format: format, actionDetail1 % 100, actionDetail2 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
