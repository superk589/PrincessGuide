//
//  UpperLimitAttackAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class UpperLimitAttackAction: ActionParameter {
 
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2))
        ]
    }

}
