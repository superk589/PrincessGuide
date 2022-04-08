//
//  SpyAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2022/4/8.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class SpyAction: ActionParameter {
    
    enum CancelType: Int {
        case none
        case damaged
    }
    
    var cancelType: CancelType {
        return CancelType(rawValue: actionDetail2) ?? .none
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch cancelType {
        case .none:
            return super.localizedDetail(of: level, property: property, style: style)
        case .damaged:
            let format = NSLocalizedString("Make %@ invisible for [%@]s, cancels on taking damage.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
}
