//
//  LoopMotionRepeatAction.swift
//  PrincessGuide
//
//  Created by zzk on 10/31/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class LoopMotionRepeatAction: ActionParameter {
    
    var successClause: String? {
        if actionDetail2 != 0 {
            let format = NSLocalizedString("use %d after time up", comment: "")
            return String(format: format, actionDetail2 % 10)
        } else {
            return nil
        }
    }
    
    var failureClause: String? {
        if actionDetail3 != 0 {
            let format = NSLocalizedString("use %d after break", comment: "")
            return String(format: format, actionDetail3 % 10)
        } else {
            return nil
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let mainFormat = NSLocalizedString("Repeat effect %d every %@s up to %@s, break if taken more than %@ damage", comment: "")
        let mainClause = String(format: mainFormat, actionDetail1 % 10, actionValue2.roundedString(roundingRule: nil), actionValue1.roundedString(roundingRule: nil), actionValue3.roundedString(roundingRule: nil))
        
        let format = NSLocalizedString("%@.", comment: "sentence and period")
        return String(format: format, [mainClause, successClause, failureClause].compactMap { $0 }.joined(separator: NSLocalizedString(", ", comment: "clause separator")))
    }

}
