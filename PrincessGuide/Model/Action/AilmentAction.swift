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
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
        ]
    }
    
    var chanceValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil)
        ]
    }
    
    var durationValues: [ActionValue] {
        return chanceValues
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch ailment.ailmentType {
        case .action:
            switch ailment.ailmentDetail {
            case .some(.action(.haste)):
                let format = NSLocalizedString("Raise %@ %d%% attack speed for [%@]s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(((actionValue1 - 1) * 100).rounded()), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            case .some(.action(.slow)):
                let format = NSLocalizedString("Reduce %@ %d%% attack speed for [%@]s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(((1 - actionValue1) * 100).rounded()), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            case .some(.action(.sleep)):
                let format = NSLocalizedString("Make %@ fall asleep for [%@]s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            default:
                let format = NSLocalizedString("%@ %@ for [%@]s.", comment: "")
                return String(format: format, ailment.description, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            }
        case .dot:
            switch ailment.ailmentDetail {
            case .some(.dot(.poison)):
                let format = NSLocalizedString("Poison %@ and deal [%@] damage per second for [%@]s.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            default:
                let format = NSLocalizedString("%@ %@ and deal [%@] damage per second for [%@]s.", comment: "")
                return String(format: format, ailment.description, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
            }
        case .silence:
            let format = NSLocalizedString("Silence %@ with [%@]%% chance for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property), buildExpression(of: level, roundingRule: nil, style: style, property: property))
        case .charm:
            let format = NSLocalizedString("Charm %@ with [%@]%% chance for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property), buildExpression(of: level, roundingRule: nil, style: style, property: property))
        case .darken:
            let format = NSLocalizedString("Blind %@ with [%@]%% chance for [%@]s, physical attack has %d%% chance to miss.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, actionValues: chanceValues, roundingRule: nil, style: style, property: property), buildExpression(of: level, roundingRule: nil, style: style, property: property), 100 - actionDetail1)
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
