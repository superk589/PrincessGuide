//
//  Skill.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum SkillCategory: String, Hashable, CustomStringConvertible {
    case unionBurst
    case main
    case ex
    case exEvolution
    case sp
    
    case mainEvolution
    case unionBurstEvolution
    
    var description: String {
        switch self {
        case .unionBurst:
            return NSLocalizedString("UB", comment: "")
        case .main:
            return NSLocalizedString("Main", comment: "")
        case .ex:
            return NSLocalizedString("EX", comment: "")
        case .exEvolution:
            return NSLocalizedString("EX+", comment: "")
        case .sp:
            return NSLocalizedString("SP", comment: "")
        case .mainEvolution:
            return NSLocalizedString("Main+", comment: "")
        case .unionBurstEvolution:
            return NSLocalizedString("UB+", comment: "")
        }
    }
}

class Skill: Codable {
    
    var actions: [Action]
    let base: Base
    
    let dependActionIDs: [Int: Int]
    
    init(actions: [Action], base: Base, dependActionIDs: [Int: Int]) {
        self.actions = actions
        self.base = base
        self.dependActionIDs = dependActionIDs
        
        for i in actions.indices {
            let action = actions[i]
            if let dependID = dependActionIDs[action.actionId], let dependAction = actions.first(where: { $0.actionId == dependID }) {
                var newAction = action
                newAction.targetCount = dependAction.targetCount
                newAction.targetAssignment = dependAction.targetAssignment
                self.actions[i] = newAction
            }
        }
    }
        
    struct Base: Codable {
        let dependAction1: Int
        let dependAction2: Int
        let dependAction3: Int
        let dependAction4: Int
        let dependAction5: Int
        let dependAction6: Int
        let dependAction7: Int
        let description: String
        let iconType: Int
        let name: String
        let skillAreaWidth: Int
        let skillCastTime: Double
        let skillId: Int
        let skillType: Int
    }
    
    struct Action: Codable {
        
        let actionDetail1: Int
        let actionDetail2: Int
        let actionDetail3: Int
        let actionId: Int
        let actionType: Int
        let actionValue1: Double
        let actionValue2: Double
        let actionValue3: Double
        let actionValue4: Double
        let actionValue5: Double
        let actionValue6: Double
        let actionValue7: Double
        let classId: Int
        let description: String
        let levelUpDisp: String
        let targetArea: Int
        var targetAssignment: Int
        var targetCount: Int
        let targetNumber: Int
        let targetRange: Int
        let targetType: Int
        
    }
    
}

extension Skill.Action {
    
    var parameter: ActionParameter {
        
        return ActionParameter.type(of: actionType).init(id: actionId, targetAssignment: targetAssignment, targetNth: targetNumber, actionType: actionType, targetType: targetType, targetRange: targetRange, direction: targetArea, targetCount: targetCount, actionValue1: actionValue1, actionValue2: actionValue2, actionValue3: actionValue3, actionValue4: actionValue4, actionValue5: actionValue5, actionValue6: actionValue6, actionValue7: actionValue7, actionDetail1: actionDetail1, actionDetail2: actionDetail2, actionDetail3: actionDetail3)
    }
    
}
