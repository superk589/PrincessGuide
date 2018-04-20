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
    
    var description: String {
        switch self {
        case .unionBurst:
            return NSLocalizedString("Union Burst", comment: "")
        case .main:
            return NSLocalizedString("Main", comment: "")
        case .ex:
            return NSLocalizedString("EX", comment: "")
        case .exEvolution:
            return NSLocalizedString("EX Evolution", comment: "")
        case .sp:
            return NSLocalizedString("SP", comment: "")
        }
    }
}

class Skill: Codable {
    
    let actions: [Action]
    let base: Base
    
    init(actions: [Action], base: Base) {
        self.actions = actions
        self.base = base
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
        let skillCastTime: String
        let skillId: Int
        let skillType: Int
    }
    
    struct Action: Codable {
        
        let actionDetail1: Int
        let actionDetail2: Int
        let actionDetail3: Int
        let actionId: Int
        let actionType: Int
        let actionValue1: String
        let actionValue2: String
        let actionValue3: String
        let actionValue4: String
        let actionValue5: String
        let actionValue6: String
        let actionValue7: String
        let classId: Int
        let description: String
        let levelUpDisp: String
        let targetArea: Int
        let targetAssignment: Int
        let targetCount: Int
        let targetNumber: Int
        let targetRange: Int
        let targetType: Int
        
    }
    
}

enum ActionKey: String, CustomStringConvertible {
    case atk
    case magicStr
    case skillLevel
    case initialValue
    
    var description: String {
        switch self {
        case .atk:
            return NSLocalizedString("ATK Coefficient", comment: "")
        case .magicStr:
            return NSLocalizedString("Magic STR Coefficient", comment: "")
        case .skillLevel:
            return NSLocalizedString("Increased Per Skill Level", comment: "")
        case .initialValue:
            return NSLocalizedString("Initial Value", comment: "")
        }
    }
}

struct ActionValue {
    let key: ActionKey
    let value: String
}

enum ActionType: Int, CustomStringConvertible {
    case unknown = 0
    case damage = 1
    case heal = 4

    var description: String {
        switch self {
        case .damage:
            return NSLocalizedString("Damage", comment: "")
        case .heal:
            return NSLocalizedString("Heal", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

enum ActionDamageClass: Int, CustomStringConvertible {
    case unknown = 0
    case physical = 1
    case magical = 2
    
    var description: String {
        switch self {
        case .magical:
            return NSLocalizedString("Magical", comment: "")
        case .physical:
            return NSLocalizedString("Physical", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

extension Skill.Action {
    
    var type: ActionType {
        return ActionType(rawValue: actionType) ?? .unknown
    }
    
    var damageClass: ActionDamageClass {
        return ActionDamageClass(rawValue: actionDetail1) ?? .unknown
    }
    
    var values: [ActionValue] {
        switch (type, damageClass) {
        case (.damage, .magical):
            return [
                ActionValue(key: .initialValue, value: actionValue1),
                ActionValue(key: .skillLevel, value: actionValue2),
                ActionValue(key: .magicStr, value: actionValue3)
            ]
        case (.damage, .physical):
            return [
                ActionValue(key: .initialValue, value: actionValue1),
                ActionValue(key: .skillLevel, value: actionValue2),
                ActionValue(key: .atk, value: actionValue3)
            ]
        case (.heal, .magical):
            return [
                ActionValue(key: .initialValue, value: actionValue1),
                ActionValue(key: .skillLevel, value: actionValue2),
                ActionValue(key: .magicStr, value: actionValue3)
            ]
        case (.heal, .physical):
            return [
                ActionValue(key: .initialValue, value: actionValue1),
                ActionValue(key: .skillLevel, value: actionValue2),
                ActionValue(key: .atk, value: actionValue3)
            ]
        default:
            return []
        }
    }
}
