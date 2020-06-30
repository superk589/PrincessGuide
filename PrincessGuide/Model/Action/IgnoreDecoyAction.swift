//
//  IgnoreDecoyAction.swift
//  PrincessGuide
//
//  Created by zzk on 6/30/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class IgnoreDecoyAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Ignore the other units' taunt when attacking %@.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause()
        )
    }
}
