//
//  HealFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class HealFieldAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2)),
            ActionValue(key: .atk, value: String(actionValue3))
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        let format = NSLocalizedString("Summon a healing field of radius %d at %@ position to heal all friendly targets [%@] HP per second for %@s.", comment: "")
        return String(format: format, Int(actionValue7), targetParameter.buildTargetClause(), buildExpression(of: level, property: property), actionValue5.description)
    }
}
