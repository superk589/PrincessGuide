//
//  EffectAction.swift
//  PrincessGuide
//
//  Created by Zhenkai Zhao on 2021/12/22.
//  Copyright © 2021 zzk. All rights reserved.
//

import Foundation

class EffectAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Add extra visual or sound effect to %@.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause()
        )
    }
}
