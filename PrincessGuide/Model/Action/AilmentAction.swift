//
//  AilmentAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AilmentAction: ActionParameter {
    
    var ailment: Ailment {
        return Ailment(type: rawActionType, detail: actionDetail1)
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2))
        ]
    }
    
    var chanceValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue3)),
            ActionValue(key: .skillLevel, value: String(actionValue4))
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch ailment.ailmentType {
        case .action:
            switch ailment.ailmentDetail {
            case .some(.action(.haste)):
                let format = NSLocalizedString("Raise %@ %d%% attack speed for %@s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(((actionValue1 - 1) * 100).rounded()), actionValue3.description)
            case .some(.action(.slow)):
                let format = NSLocalizedString("Reduce %@ %d%% attack speed for %@s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(((1 - actionValue1) * 100).rounded()), actionValue3.description)
            case .some(.action(.sleep)):
                let format = NSLocalizedString("Make %@ fall asleep for %@s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), actionValue3.description)
            default:
                let format = NSLocalizedString("%@ %@ for %@s.", comment: "")
                return String(format: format, ailment.description, targetParameter.buildTargetClause(), actionValue3.description)
            }
        case .dot:
            switch ailment.ailmentDetail {
            case .some(.dot(.poison)):
                let format = NSLocalizedString("Poison %@ and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
            default:
                let format = NSLocalizedString("%@ %@ and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, ailment.description, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
            }
        case .silence:
            let format = NSLocalizedString("Silence %@ with [%d]%% chance for %@s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), Int(actionValue3), actionValue1.description)
        case .charm:
            let format = NSLocalizedString("Charm %@ with [%d]%% chance for %@s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), Int(actionValue3), actionValue1.description)
        case .darken:
            let format = NSLocalizedString("Darken %@ with [%@]%% chance for %@s, physical attack has %d%% chance to miss.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues), buildExpression(of: level), actionDetail1)
        default:
            return super.localizedDetail(of: level)
        }
    }
}
