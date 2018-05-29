//
//  ChangeEnergyAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangeEnergyAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2)),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        
        switch actionDetail1 {
        case 1:
            let format = NSLocalizedString("Restore %@ [%@] TP.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, property: property))
        default:
            let format = NSLocalizedString("Make %@ lose [%@] TP.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, property: property))
        }
    }
}
