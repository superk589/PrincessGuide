//
//  KnockAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class KnockAction: ActionParameter {
    
    enum KnockType: Int {
        case unknown = 0
        case upDown = 1
        case up
        case back
        case moveTarget
        case moveTargetParaboric
        case backLimited
    }
    
    var knockType: KnockType {
        return KnockType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch knockType {
        case .upDown:
            let format = NSLocalizedString("Knock %@ up %d.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), Int(actionValue1))
        case .back, .backLimited:
            let format: String
            if actionValue1 >= 0 {
                format = NSLocalizedString("Knock %@ away %d.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(actionValue1))
            } else {
                format = NSLocalizedString("Draw %@ toward self %d.", comment: "")
                return String(format: format, targetParameter.buildTargetClause(), Int(-actionValue1))
            }
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
 
    }
}
