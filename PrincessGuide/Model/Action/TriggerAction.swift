//
//  TriggerAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class TriggerAction: ActionParameter {
    
    enum TriggerType: Int {
        case unknown = 0
        case dodge = 1
        case damage
        case hp
        case dead
        case critical
        case criticalWithSummon
        case limitTime
        case stealthFree
    }
    
    var triggerType: TriggerType {
        return TriggerType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch triggerType {
        case .hp:
            let format = NSLocalizedString("Trigger: HP is below %d%%.", comment: "")
            return String(format: format, Int(actionValue3.rounded()))
        case .limitTime:
            let format = NSLocalizedString("Trigger: Left time is below %@s.", comment: "")
            return String(format: format, actionValue3.description)
        case .damage:
            let format = NSLocalizedString("Trigger: %d%% on damaged.", comment: "")
            return String(format: format, Int(actionValue1.rounded()))
        case .dead:
            let format = NSLocalizedString("Trigger: %d%% on dead.", comment: "")
            return String(format: format, Int(actionValue1.rounded()))
        case .stealthFree:
            let format = NSLocalizedString("Trigger: %d%% on stealth.", comment: "")
            return String(format: format, Int(actionValue1.rounded()))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
