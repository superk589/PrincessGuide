//
//  MoveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class MoveAction: ActionParameter {
    
    enum MoveType: Int {
        case unknown = 0
        case targetReturn
        case absoluteReturn
        case target
        case absolute
        case targetByVelocity
        case absoluteByVelocity
    }
    
    var moveType: MoveType {
        return MoveType(rawValue: actionDetail1) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
//        switch moveType {
//        case .targetReturn:
//            let format = NSLocalizedString("Change self position to %@ then return.", comment: "")
//            return String(format: format, targetParameter.buildTargetClause())
//        case .absoluteReturn:
//            if actionValue1 > 0 {
//                let format = NSLocalizedString("Change self position %@ forward then return.", comment: "")
//                return String(format: format, actionValue1.description)
//            } else {
//                let format = NSLocalizedString("Change self position %@ backward then return.", comment: "")
//                return String(format: format, (-actionValue1).description)
//            }
//        case .target:
//            let format = NSLocalizedString("Change self position to %@.", comment: "")
//            return String(format: format, targetParameter.buildTargetClause())
//        case .absolute:
//            if actionValue1 > 0 {
//                let format = NSLocalizedString("Change self position %@ forward.", comment: "")
//                return String(format: format, actionValue1.description)
//            } else {
//                let format = NSLocalizedString("Change self position %@ backward.", comment: "")
//                return String(format: format, (-actionValue1).description)
//            }
//        case .targetByVelocity:
//            if actionValue1 > 0 {
//                let format = NSLocalizedString("Move to %@ in front of %@ with velocity %@/s.", comment: "")
//                return String(format: format, actionValue1.description, targetParameter.buildTargetClause(), actionValue2.description)
//            } else {
//                let format = NSLocalizedString("Move to %@ behind of %@ with velocity %@/s.", comment: "")
//                return String(format: format, (-actionValue1).description, targetParameter.buildTargetClause(), actionValue2.description)
//            }
//        case .absoluteByVelocity:
//            if actionValue1 > 0 {
//                let format = NSLocalizedString("Move forward %@ with velocity %@/s.", comment: "")
//                return String(format: format, actionValue1.description, actionValue2.description)
//            } else {
//                let format = NSLocalizedString("Move backward %@ with velocity %@/s.", comment: "")
//                return String(format: format, (-actionValue1).description, actionValue2.description)
//            }
//        default:
//            return super.localizedDetail(of: level, property: property, style: style)
//        }
        let format = NSLocalizedString("Change self position.", comment: "")
        return String(format: format)
    }
    
}
