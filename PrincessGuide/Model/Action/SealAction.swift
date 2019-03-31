//
//  SealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SealAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        let format = NSLocalizedString("Mark %@ with state of ID: %@ with max stacks of %@ for %@s.", comment: "")
        return String(format: format, targetParameter.buildTargetClause(), actionValue2.roundedValueString(.down), actionValue1.roundedValueString(.down), actionValue3.description)
    }
}
