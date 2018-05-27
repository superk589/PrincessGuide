//
//  HealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class HealAction: ActionParameter {
    
    var healClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    var pecentModifier: PercentModifier {
        return PercentModifier(Int(actionValue1))
    }
    
    override var actionValues: [ActionValue] {
        switch healClass {
        case .magical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .magicStr, value: String(actionValue4))
            ]
        case .physical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .atk, value: String(actionValue4))
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Restore %@ [%@]%@ HP.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level), pecentModifier.description)
    }
    
}
