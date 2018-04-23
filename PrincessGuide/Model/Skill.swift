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
    case duration
    
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
        case .duration:
            return NSLocalizedString("Duration", comment: "")
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
    case stun = 8
    case ex = 90

    var description: String {
        switch self {
        case .damage:
            return NSLocalizedString("Damage", comment: "")
        case .heal:
            return NSLocalizedString("Heal", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        case .stun:
            return NSLocalizedString("Stun", comment: "")
        case .ex:
            return NSLocalizedString("EX", comment: "")
        }
    }
}

enum ActionClass: Int, CustomStringConvertible {
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

extension Property {
    init?(_ value: Int) {
        switch value {
        case 1:
            self = .hp
        case 2:
            self = .atk
        case 3:
            self = .def
        case 4:
            self = .magicStr
        case 5:
            self = .magicDef
        default:
            return nil
        }
    }
}

extension Skill.Action {
    
    var type: ActionType {
        return ActionType(rawValue: actionType) ?? .unknown
    }
    
    var `class`: ActionClass {
        return ActionClass(rawValue: actionDetail1) ?? .unknown
    }
    
    var values: [ActionValue] {
        switch (type, `class`) {
        case (.damage, .magical):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case (.damage, .physical):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        case (.heal, .magical):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case (.heal, .physical):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        case (.ex, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
            ]
        case (.stun, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        default:
            return []
        }
    }
    
    private func buildActionDescription() -> String {
        switch type {
        case .heal:
            return NSLocalizedString("Restore [%@] HP", comment: "")
        case .damage:
            return NSLocalizedString("Deal [%@] \(`class`) Damage", comment: "")
        case .ex:
            return NSLocalizedString("Raise [%@] \(Property(actionDetail1)?.description ?? NSLocalizedString("Unknown", comment: ""))", comment: "")
        case .stun:
            return NSLocalizedString("Stun for [%@]s", comment: "")
        default:
            return NSLocalizedString("Unknwon", comment: "")
        }
    }
    
    private func buildValueDescription() -> String {
        var result = ""
        var fixedValue = 0.0
        for value in values {
            switch value.key {
            case .atk:
                result += "\(value.value) * \(Property.atk)"
            case .magicStr:
                result += "\(value.value) * \(Property.magicStr)"
            case .skillLevel:
                fixedValue += Double(Config.maxPlayerLevel - 1) * (Double(value.value) ?? 0)
            case .initialValue:
                fixedValue += Double(value.value) ?? 0
            case .duration:
                fixedValue = Double(value.value) ?? 0
            }
        }
        
        var valueString = ""
        switch type {
        case .damage, .heal, .ex:
            valueString = String(Int(floor(fixedValue)))
        default:
            valueString = String(fixedValue)
        }
        
        if result != "" {
            return "\(result) + \(valueString)@\(Config.maxPlayerLevel)"
        } else {
            return "\(valueString)@\(Config.maxPlayerLevel)"
        }
    }
    
    var longDescription: String {
        let actionDescription = buildActionDescription()
        let valueDescription = buildValueDescription()
        return String(format: actionDescription, valueDescription)
    }
}
