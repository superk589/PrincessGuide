//
//  ChangeBodyWidthAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/2/28.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class ChangeBodyWidthAction: ActionParameter {

    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        let format = NSLocalizedString("Change body width to %@.", comment: "")
        return String(format: format, actionValue1.description)
    }
}
