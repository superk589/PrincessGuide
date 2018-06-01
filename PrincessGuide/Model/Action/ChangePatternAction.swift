//
//  ChangePatternAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ChangePatterAction: ActionParameter {
    
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionDetail1 {
        case 1:
            let format = NSLocalizedString("Change attack pattern to %d for %@s.", comment: "")
            return String(format: format, actionDetail2 % 10, actionValue1.description)
        default:
            /// FIXME: this action seems do nothing but visual effect change
            return super.localizedDetail(of: level)
        }
    }
}
