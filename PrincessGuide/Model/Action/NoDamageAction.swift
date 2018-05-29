//
//  NoDamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class NoDamageAction: ActionParameter {
    
    enum NoDamageType: Int {
        case unknown = 0
        case noDisplay = 1
        case display
        case onlyDamageNum
        case abnormal
        case debuff
    }
    
    var noDamageType: NoDamageType {
        return NoDamageType(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2)),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero) -> String {
        switch noDamageType {
        case .noDisplay:
            let format = NSLocalizedString("Become invulnerable for [%@]s.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: nil, property: property))
        default:
            return super.localizedDetail(of: level)
        }
    }
}
