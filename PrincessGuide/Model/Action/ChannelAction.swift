//
//  ChannelAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ChannelAction: AuraAction {

    enum ReleaseType: Int {
        case damage = 1
        case unknown
    }
    
    var releaseType: ReleaseType {
        return ReleaseType(rawValue: actionDetail2) ?? .unknown
    }
    
    override func localizedDetail(of level: Int, property: Property, style: CDSettingsViewController.Setting.ExpressionStyle) -> String {
        switch releaseType {
        case .damage:
            let format = NSLocalizedString("Channel for [%@]s, interruptible by receiving damange %d times, %@ %@ [%@]%@ %@.", comment: "")
            return String(
                format: format,
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property),
                actionDetail3,
                auraActionType.description,
                targetParameter.buildTargetClause(),
                buildExpression(of: level, roundingRule: .awayFromZero, style: style, property: property),
                percentModifier.description,
                auraType.description
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
   
}
