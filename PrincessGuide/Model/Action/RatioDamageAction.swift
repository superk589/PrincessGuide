//
//  RatioDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class RatioDamageAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch hpType {
        case .max:
            let format = NSLocalizedString("Deal damage equal to [%@]%% of target's max HP to %@.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property), targetParameter.buildTargetClause())
        case .current:
            let format = NSLocalizedString("Deal damage equal to [%@]%% of target's current HP to %@.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property), targetParameter.buildTargetClause())
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
    var hpType: HPType {
        return HPType(rawValue: actionDetail1) ?? .unknown
    }
    
    enum HPType: Int {
        case unknown = 0
        case max = 1
        case current
    }
}
