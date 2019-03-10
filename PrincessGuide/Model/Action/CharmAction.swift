//
//  CharmAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/2/28.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class CharmAction: ActionParameter {
    
    var chanceValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3 * 100), perLevel: String(actionValue4 * 100), key: nil)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
        ]
    }
    
    var charmType: CharmType {
        return CharmType(rawValue: actionDetail1) ?? .unknown
    }
    
    enum CharmType: Int {
        case unknown = -1
        case charm = 0
        case confusion
    }
    
    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        
        switch charmType {
        case .charm:
            let format = NSLocalizedString("Charm %@ with [%@]%% chance for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
        case .confusion:
            let format = NSLocalizedString("Confuse %@ with [%@]%% chance for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
