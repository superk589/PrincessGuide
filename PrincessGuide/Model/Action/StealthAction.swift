//
//  StealthAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/4/30.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class StealthAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Stealth for %@s.", comment: "")
        return String(format: format, actionValue1.roundedString(roundingRule: nil))
    }
    
}
