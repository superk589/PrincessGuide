//
//  StopFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/6/30.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class StopFieldAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Remove field of skill %d (1 represents the first skill in this list) effect %d.", comment: "")
        return String(
            format: format,
            actionDetail1 / 100 % 10,
            actionDetail1 % 10
        )
    }
    
}
