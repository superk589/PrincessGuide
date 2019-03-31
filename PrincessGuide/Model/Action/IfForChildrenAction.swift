//
//  IfForChildrenAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class IfForChildrenAction: ActionParameter {
    
    var trueClause: String? {
        guard actionDetail2 != 0 else {
            return nil
        }

        switch actionDetail1 {
        case 100:
            let format = NSLocalizedString("use %d to any of %@ is controlled", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 200:
            let format = NSLocalizedString("use %d to any of %@ is blinded", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 300:
            let format = NSLocalizedString("use %d to any of %@ is charmed", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 500:
            let format = NSLocalizedString("use %d to any of %@ is burned", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 501:
            let format = NSLocalizedString("use %d to any of %@ is cursed", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 502:
            let format = NSLocalizedString("use %d to any of %@ is poisoned", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 503:
            let format = NSLocalizedString("use %d to any of %@ is violently poisoned", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause())
        case 600..<900:
            let format = NSLocalizedString("use %d to any of %@ is in state of ID: %d", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
        case 901..<1000:
            let format = NSLocalizedString("use %d to any of %@ whose HP is below %d%%", comment: "")
            return String(format: format, actionDetail2 % 10, targetParameter.buildTargetClause(), actionDetail1 - 900)
        default:
            return nil
        }
        
    }
    
    var falseClause: String? {
        guard actionDetail3 != 0 else {
            return nil
        }
        
        switch actionDetail1 {
        case 100:
            let format = NSLocalizedString("use %d to any of %@ is not controlled", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 200:
            let format = NSLocalizedString("use %d to any of %@ is not blinded", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 300:
            let format = NSLocalizedString("use %d to any of %@ is not charmed", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 500:
            let format = NSLocalizedString("use %d to any of %@ is not burned", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 501:
            let format = NSLocalizedString("use %d to any of %@ is not cursed", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 502:
            let format = NSLocalizedString("use %d to any of %@ is not poisoned", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 503:
            let format = NSLocalizedString("use %d to any of %@ is not violently poisoned", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause())
        case 600..<900:
            let format = NSLocalizedString("use %d to any of %@ is not in state of ID: %d", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 600)
        case 901..<1000:
            let format = NSLocalizedString("use %d to any of %@ whose HP is not below %d%%", comment: "")
            return String(format: format, actionDetail3 % 10, targetParameter.buildTargetClause(), actionDetail1 - 900)
        default:
            return nil
        }
        
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        
        switch actionDetail1 {
        case 100, 200, 300, 500, 501, 502, 503, 600..<900, 901..<1000:
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
