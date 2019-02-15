//
//  ModeChangeAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ModeChangeAction: ActionParameter {
    
    enum ModeChangeType: Int {
        case unknown = 0
        case time = 1
        case energy
        case release
    }
    
    var modeChangeType: ModeChangeType {
        return ModeChangeType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        switch modeChangeType {
        case .unknown:
            return super.localizedDetail(of: level, property: property, style: style)
        case .time:
            let format = NSLocalizedString("Change attack pattern to %d for %@s.", comment: "")
            return String(format: format, actionDetail2 % 10, actionValue1.description)
        case .energy:
            let format = NSLocalizedString("Cost %@ TP/s, change attack pattern to %d until TP is zero.", comment: "")
            return String(format: format, actionValue1.roundedValueString(.down), actionDetail2 % 10)
        case .release:
            let format = NSLocalizedString("Change attack pattern back to %d after effect over.", comment: "")
            return String(format: format, actionDetail2 % 10)
        }
    }
    
}
