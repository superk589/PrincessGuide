//
//  EnchantStrikeBackAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class EnchantStrikeBackAction: BarrierAction {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch barrierType {
        case .physicalGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage when taking physical damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        case .magicalGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage when taking magical damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        case .physicalDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage and recover the same HP when taking physical damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        case .magicalDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage and recover the same HP when taking magical damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        case .bothDrain:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage and recover the same HP when taking damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        case .bothGuard:
            let format = NSLocalizedString("Cast a barrier on %@ to strike back [%@] damage when taking damage.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
