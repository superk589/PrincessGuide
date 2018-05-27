//
//  AccumulativeDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AccumulativeDamageAction: ActionParameter {
 
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue2)),
            ActionValue(key: .skillLevel, value: String(actionValue3))
        ]
    }
    
    override func localizedDetail(of level: Int) -> String {
        let format = NSLocalizedString("Add additional [%@] damage per attack with max %d stacks to current target.", comment: "")
        return String(format: format, buildExpression(of: level), Int(actionValue4))
    }
    
}
