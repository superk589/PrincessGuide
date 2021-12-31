//
//  DamageAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class DamageAction: ActionParameter {
    
    var damageClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    enum DecideTargetAtkType: Int {
        case bySource
        case lowerDef
    }
    
    override var actionValues: [ActionValue] {
        switch damageClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        case .physical, .inevitablePhysical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        default:
            return []
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        var string: String
        
        switch actionValue5 {
        case 0:
            let format = NSLocalizedString("Deal [%@] %@ damage to %@.", comment: "")
            string = String(format: format, buildExpression(of: level, style: style, property: property), damageClass.description, targetParameter.buildTargetClause())
        case let x where x > 0:
            let format = NSLocalizedString("Deal [%@] %@ damage to %@, and the %@-th hit of this attack is ensured critical.", comment: "")
            string = String(
                format: format,
                buildExpression(of: level, style: style, property: property),
                damageClass.description,
                targetParameter.buildTargetClause(),
                x.roundedString(roundingRule: nil)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
        
        if actionValue6 != 0 {
            let format = NSLocalizedString(" Critical damage is %@ times as normal damage.", comment: "")
            string.append(String(format: format, (2 * actionValue6).roundedString(roundingRule: nil)))
        }
        
        if let type = DecideTargetAtkType(rawValue: actionDetail2) {
            switch type {
            case .lowerDef:
                let format = NSLocalizedString(" This damage is calculated by selecting the lower DEF type of the target.", comment: "")
                string.append(String(format: format, (2 * actionValue6).roundedString(roundingRule: nil)))
            default:
                break
            }
        }
        
        return string
    }
    
}
