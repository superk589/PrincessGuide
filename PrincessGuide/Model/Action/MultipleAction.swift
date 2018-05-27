//
//  MultipleAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class MultipleAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue2)),
            ActionValue(key: .skillLevel, value: String(actionValue3))
        ]
    }
    
    override func localizedDetail(of level: Int) -> String {
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("Multiple [%@ * HP / max HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none))
        case 1:
            let format = NSLocalizedString("Multiple [%@ * lost HP / max HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none))
        case 2:
            let format = NSLocalizedString("Multiple [%@ * defeated enemy count] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level))
        default:
            return super.localizedDetail(of: level)
        }
    }
}
