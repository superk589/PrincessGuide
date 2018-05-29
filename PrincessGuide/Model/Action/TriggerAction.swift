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
    }
    
    var triggerType: TriggerType {
        return TriggerType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        switch triggerType {
        case .hp:
            let format = NSLocalizedString("Condition: HP is below %d%%.", comment: "")
            return String(format: format, Int(actionValue3.rounded()))
        default:
            return super.localizedDetail(of: level)
        }
    }
    
}
