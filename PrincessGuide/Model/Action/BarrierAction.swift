//
//  BarrierAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class BarrierAction: ActionParameter {
    
    enum BarrierType: Int {
        case unknown = 0
        case physicalGuard = 1
        case magicalGuard
        case physicalDrain
        case magicalDrain
        case bothGuard
        case bothDrain
    }
    
    var barrierType: BarrierType {
        return BarrierType(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch barrierType {
        case .unknown:
            let format = NSLocalizedString("Cast an unknown barrier %d on %@ for [%@]s.", comment: "")
            return String(format: format, actionDetail1, targetParameter.buildTargetClause(), actionValue3.description)
        case .physicalGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to nullify [%@] physical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        case .magicalGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to nullify [%@] magical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        case .physicalDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] physical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        case .magicalDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] magical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        case .bothDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] physical and magical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        case .bothGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to nullify [%@] physical and magical damage for [%@]s.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), actionValue3.description)
        }
    }
}
