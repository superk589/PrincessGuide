//
//  CountBlindAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/31.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class CountBlindAction: ActionParameter {

    enum CountType: Int {
        case unknown = -1
        case time = 1
        case count = 2
    }
    
    var countType: CountType {
        return CountType(rawValue: Int(actionValue1)) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch countType {
        case .time:
            let format = NSLocalizedString("In next [%@]s, %@'s physical attacks will miss.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, style: style, property: property), targetParameter.buildTargetClause())
        case .count:
            let format = NSLocalizedString("In next [%@] attacks, %@'s physical attacks will miss.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property), targetParameter.buildTargetClause())
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
