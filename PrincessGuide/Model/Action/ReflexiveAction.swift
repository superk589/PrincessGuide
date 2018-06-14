//
//  ReflexiveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ReflexiveAction: ActionParameter {
    
    enum RefrexiveType: Int {
        case unknown = 0
        case normal = 1
        case search
        case position
    }
    
    private var refrexiveType: RefrexiveType {
        return RefrexiveType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch (targetParameter.targetType, refrexiveType) {
        case (.absolute, _):
            let format = NSLocalizedString("Change the perspective to %@ %d.", comment: "")
            return String(format: format, targetParameter.direction.rawDescription, Int(actionValue1))
        case (_, .search):
            let format = NSLocalizedString("Scout and change the perspective on %@.", comment: "")
            return String(format: format, targetParameter.buildTargetClause())
        default:
            let format = NSLocalizedString("Change the perspective on %@.", comment: "")
            return String(format: format, targetParameter.buildTargetClause())
        }
    }
}
