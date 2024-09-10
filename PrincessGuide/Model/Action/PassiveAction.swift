//
//  PassiveAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class PassiveAction: ActionParameter {
    
    var propertyKey: PropertyKey {
        switch actionDetail1 {
        case 1:
            return .hp
        case 2:
            return .atk
        case 3:
            return .def
        case 4:
            return .magicStr
        case 5:
            return .magicDef
        case 6:
            return .physicalCritical
        case 7:
            return .magicCritical
        default:
            return .unknown
        }
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Raise [%@] %@.", comment: "Raise [x] ATK.")
        return String(format: format, buildExpression(of: level, style: style, property: property), propertyKey.description)
    }
    
    func propertyItem(of level: Int) -> Property.Item {
        return Property.Item(key: propertyKey, value: floor(actionValue2 + actionValue3 * Double(level)))
    }
}
