//
//  SummonAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class SummonAction: ActionParameter {
    
    enum Side: Int, CustomStringConvertible {
        case unknown = -1
        case ours = 1
        case other = 2
        
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("unknown side", comment: "")
            case .ours:
                return NSLocalizedString("own side", comment: "")
            case .other:
                return NSLocalizedString("opposite", comment: "")
            }
        }
    }
    
    enum UnitType: Int,CustomStringConvertible {
        case unknown = -1
        case normal = 1
        case phantom
        
        var description: String {
            switch self {
            case .unknown:
                return NSLocalizedString("unknown type", comment: "")
            case .normal:
                return NSLocalizedString("normal type", comment: "")
            case .phantom:
                return NSLocalizedString("phantom type", comment: "")
            }
        }
    }
    
    var side: Side {
        return Side(rawValue: actionDetail3) ?? .unknown
    }
    
    var unitType: UnitType {
        return UnitType(rawValue: Int(actionValue5)) ?? .unknown
    }

    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        if actionValue7 > 0 {
            let format = NSLocalizedString("At %d in front of %@, summon a minion(ID: %d).", comment: "")
            return String(format: format, Int(actionValue7), targetParameter.buildTargetClause(), actionDetail2)
        } else if actionValue7 < 0 {
            let format = NSLocalizedString("At %d behind of %@, summon a minion(ID: %d).", comment: "")
            return String(format: format, Int(-actionValue7), targetParameter.buildTargetClause(), actionDetail2)
        } else {
            let format = NSLocalizedString("At the position of %@, summon a minion(ID: %d).", comment: "")
            return String(format: format, targetParameter.buildTargetClause(), actionDetail2)
        }
    }
    
    lazy var minion: Minion? = {
        let minion = DispatchSemaphore.sync { (closure) in
            return Master.shared.getUnitMinion(minionID: actionDetail2, callback: closure)
        }
        minion?.shouldApplyPassiveSkills = self.actionDetail1 == 3
        return minion
    }()
    
    lazy var enemyMinion: Enemy? = DispatchSemaphore.sync { (closure) in
        return Master.shared.getEnemyMinion(minionID: actionDetail2, callback: closure)
    }
    
}
