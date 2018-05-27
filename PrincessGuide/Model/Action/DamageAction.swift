//
//  DamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class DamageAction: ActionParameter {
    
    var damageClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        switch damageClass {
        case .magical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case .physical:
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Deal [%@] %@ damage to %@.", comment: "")
        return String(format: format, buildExpression(of: level), damageClass.description, targetParameter.buildTargetClause())
    }
    
}
