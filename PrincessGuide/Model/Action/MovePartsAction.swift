//
//  MovePartsAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/22.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class MovePartsAction: ActionParameter {

    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Move Part %d, %d forward then return.", comment: "")
        return String(format: format, Int(actionValue4), -Int(actionValue1))
    }
    
}
