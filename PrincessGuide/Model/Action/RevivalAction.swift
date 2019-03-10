//
//  RevivalAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class RevivalAction: ActionParameter {
    
    enum RevivalType: Int {
        case unknown = 0
        case normal
        case phoenix
    }
    
    var revivalType: RevivalType {
        return RevivalType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        
        switch revivalType {
        case .normal:
            let format = NSLocalizedString("Revive %@ with %d%% HP.", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), Int(actionValue2.rounded() * 100))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
