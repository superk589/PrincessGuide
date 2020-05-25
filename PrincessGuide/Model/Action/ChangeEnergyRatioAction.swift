//
//  ChangeEnergyRatioAction.swift
//  PrincessGuide
//
//  Created by zzk on 5/25/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class ChangeEnergyRatioAction: ActionParameter {
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Multiple the energy gained by %@ from effects [%@] with [%@].", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            children.map(\.parameter.id).map { String($0 % 10) }.joined(separator: ", "),
            zip(0..<children.count, rawActionValues).map { $0.1.roundedString(roundingRule: nil) }.joined(separator: ", ")
        )
    }
}
