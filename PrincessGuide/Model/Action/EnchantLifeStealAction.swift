//
//  EnchantLifeStealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class EnchantLifeStealAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue2)),
            ActionValue(key: .skillLevel, value: String(actionValue3))
        ]
    }
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Add additional [%@] %@ to %@ for next attack within %@s.", comment: "")
        return String(format: format, buildExpression(of: level), PropertyKey.lifeSteal.description, targetParameter.buildTargetClause(), actionValue1.description)
        
    }
}
