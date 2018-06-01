//
//  ReflexiveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ReflexiveAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch targetParameter.targetType {
        case .absolute:
            let format = NSLocalizedString("Change the perspective to %@ %d.", comment: "")
            return String(format: format, targetParameter.direction.rawDescription, Int(actionValue1))
        default:
            let format = NSLocalizedString("Change the perspective on %@.", comment: "")
            return String(format: format, targetParameter.buildTargetClause())
        }
    }
}
