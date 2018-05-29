//
//  ChangeParameterFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangeParameterFieldAction: AuraAction {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2))
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        let format = NSLocalizedString("Summon a field of radius %d to %@ %@ [%@]%@ %@ for %@s.", comment: "")
        return String(format: format, Int(actionValue5), auraActionType.description.lowercased(), targetParameter.buildTargetClause(), buildExpression(of: level, property: property), percentModifier.description, auraType.description, actionValue3.description)
    }
}
