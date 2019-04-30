//
//  IFExistsFieldForAllAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/1/31.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class IFExistsFieldForAllAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        if actionDetail2 != 0 && actionDetail3 != 0 {
            let format = NSLocalizedString("Condition: if the specific field exists then use %d, otherwise %d.", comment: "")
            return String(format: format, actionDetail2 % 10, actionDetail3 % 10)
        } else if actionDetail2 != 0 {
            let format = NSLocalizedString("Condition: if the specific field exists then use %d.", comment: "")
            return String(format: format, actionDetail2 % 10)
        } else {
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
