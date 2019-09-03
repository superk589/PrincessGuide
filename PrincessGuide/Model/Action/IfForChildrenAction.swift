//
//  IfForChildrenAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum IfType: Int, CustomStringConvertible {
    case controllered = 100
    case blind = 200
    case convert = 300
    case decoy = 400
    case burn = 500
    case curse
    case poison
    case venom
    case poisonOrVenon = 512
    
    var description: String {
        switch self {
        case .controllered:
            return NSLocalizedString("controlled", comment: "")
        case .blind:
            return NSLocalizedString("blinded", comment: "")
        case .convert:
            return NSLocalizedString("charmed or confused", comment: "")
        case .decoy:
            return NSLocalizedString("decoying", comment: "")
        case .burn:
            return NSLocalizedString("burned", comment: "")
        case .curse:
            return NSLocalizedString("cursed", comment: "")
        case .poison:
            return NSLocalizedString("poisoned", comment: "")
        case .venom:
            return NSLocalizedString("venomed", comment: "")
        case .poisonOrVenon:
            return NSLocalizedString("poisoned or venomed", comment: "")
        }
    }
}

class IfForChildrenAction: ActionParameter {
    
    var trueClause: String? {
        guard actionDetail2 != 0 else {
            return nil
        }
        
        if let ifType = IfType(rawValue: actionDetail1) {
            let format = NSLocalizedString("use %d to any of %@ is %@", comment: "")
            return String(format: format, actionDetail2 % 100, targetParameter.buildTargetClause(), ifType.description)
        } else {
            switch actionDetail1 {
            case 600..<700:
                let format = NSLocalizedString("use %d to any of %@ is in state of ID: %d", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
            case 700:
                let format = NSLocalizedString("use %d to %@ if it's alone", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
            case 901..<1000:
                let format = NSLocalizedString("use %d to any of %@ whose HP is below %d%%", comment: "")
                return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 900)
            default:
                return nil
            }
        }
    }
    
    var falseClause: String? {
        guard actionDetail3 != 0 else {
            return nil
        }
        if let ifType = IfType(rawValue: actionDetail1) {
            let format = NSLocalizedString("use %d to any of %@ is not %@", comment: "")
            return String(format: format, actionDetail3 % 100, targetParameter.buildTargetClause(), ifType.description)
        } else {
            switch actionDetail1 {
            case 600..<700:
                let format = NSLocalizedString("use %d to any of %@ is not in state of ID: %d", comment: "")
                return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
            case 700:
                let format = NSLocalizedString("use %d to %@ if it's not alone", comment: "")
                return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
            case 901..<1000:
                let format = NSLocalizedString("use %d to any of %@ whose HP is not below %d%%", comment: "")
                return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 900)
            default:
                return nil
            }
        }
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch actionDetail1 {
        case 100, 200, 300, 500, 501, 502, 503, 512, 600..<900, 901..<1000:
            let format = NSLocalizedString("Condition: %@.", comment: "")
            return String(format: format, [trueClause, falseClause].compactMap { $0 }.joined(separator: NSLocalizedString(", ", comment: "clause separator")))
        case 0..<100:
            if actionDetail2 != 0 && actionDetail3 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d, otherwise %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10, actionDetail3 % 10)
            } else if actionDetail2 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d.", comment: "")
                return String(format: format, actionDetail1, actionDetail2 % 10)
            } else if actionDetail3 != 0 {
                let format = NSLocalizedString("Random event: %d%% chance use %d.", comment: "")
                return String(format: format, 100 - actionDetail1, actionDetail3 % 10)
            } else {
                return super.localizedDetail(of: level, property: property, style: style)
            }
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
