//
//  RatioDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class RatioDamageAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2))
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        let format = NSLocalizedString("Deal damage equal to [%@]%% of target's max HP to %@.", comment: "")
        return String(format: format, buildExpression(of: level, property: property), targetParameter.buildTargetClause())
    }
}
