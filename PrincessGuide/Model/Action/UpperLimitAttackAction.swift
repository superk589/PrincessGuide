//
//  UpperLimitAttackAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class UpperLimitAttackAction: DamageAction {
    
    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        let superString = super.localizedDetail(of: level, property: property, style: style)
        
        /// FIXME: what's the amount of reduced damage is not clear by now.
        let format = NSLocalizedString("%@ Damage is reduced on low level players.", comment: "")
        return String(format: format, superString)
    }
}
