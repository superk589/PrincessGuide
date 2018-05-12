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
            return NSLocalizedString("UB", comment: "")
        case .main:
            return NSLocalizedString("Main", comment: "")
        case .ex:
            return NSLocalizedString("EX", comment: "")
        case .exEvolution:
            return NSLocalizedString("EX+", comment: "")
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

enum ActionKey: String {
    case atk
    case magicStr
    case def
    case skillLevel
    case initialValue
    case duration
    case chance
    case stack
    case distance
    case speed
    
//    var description: String {
//        switch self {
//        case .atk:
//            return NSLocalizedString("ATK Coefficient", comment: "")
//        case .magicStr:
//            return NSLocalizedString("Magic STR Coefficient", comment: "")
//        case .skillLevel:
//            return NSLocalizedString("Increased Per Skill Level", comment: "")
//        case .initialValue:
//            return NSLocalizedString("Initial Value", comment: "")
//        case .duration:
//            return NSLocalizedString("Duration", comment: "")
//        case .chance:
//            return NSLocalizedString("Chance", comment: "")
//        case .stack:
//            return NSLocalizedString("Stack", comment: "")
//        case .def:
//            return NSLocalizedString("DEF", comment: "")
//        case .distance:
//            return NSLocalizedString("Distance", comment: "")
//        case .speed:
//            return NSLocalizedString("Speed", comment: "")
//        }
//    }
}

struct ActionValue {
    let key: ActionKey
    let value: String
}

enum ActionType: Int {
    case unknown = 0
    case damage
    case position
    case knock
    case heal
    
    case `guard` = 6
    case chooseArea
    
    case aura = 10
    case summon = 15
    case tp = 16
    
    case taunt = 20
    case invulnerable
    
    case instantDeath = 30
    case additionalDamage = 34
    case healingPool = 37
    case defDownPoll = 38
    
    case ex = 90
}

enum ActionClass: Int, CustomStringConvertible {
    case unknown = 0
    case physical
    case magical
    case physicalAbsorb
    case magicalAbsorb
    case physicalMagicAbsorb = 6
    
    var description: String {
        switch self {
        case .magical:
            return NSLocalizedString("magical damage", comment: "")
        case .physical:
            return NSLocalizedString("physical damage", comment: "")
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
        case .physicalAbsorb:
            return NSLocalizedString("physical absorb field", comment: "")
        case .magicalAbsorb:
            return NSLocalizedString("magical absorb field", comment: "")
        case .physicalMagicAbsorb:
            return NSLocalizedString("physical and magical absorb field", comment: "")
        }
    }
    
}

enum PercentModifier: CustomStringConvertible {
    case percent
    case number
    
    var description: String {
        switch self {
        case .percent:
            return "%"
        case .number:
            return ""
        }
    }
    
    init(_ value: Int) {
        switch value {
        case 2:
            self = .percent
        default:
            self = .number
        }
    }
}

enum AuraModifier: CustomStringConvertible {
    
    case raise
    case reduce
    
    case restore
    case steal
    
    var description: String {
        switch self {
        case .raise:
            return NSLocalizedString("Raise", comment: "")
        case .reduce:
            return NSLocalizedString("Reduce", comment: "")
        case .restore:
            return NSLocalizedString("Restore", comment: "")
        case .steal:
            return NSLocalizedString("Steal", comment: "")
        }
    }
    
    init(_ value: Int) {
        switch value {
        case 11, 21, 31, 41:
            self = .reduce
        case 1:
            self = .restore
        case 2:
            self = .steal
        default:
            self = .raise
        }
    }
}

extension PropertyKey {
    init?(_ value: Int) {
        switch value {
        case 1:
            self = .hp
        case 2, 10, 11:
            self = .atk
        case 3, 20, 21:
            self = .def
        case 4, 30, 31:
            self = .magicStr
        case 5, 40, 41:
            self = .magicDef
        case 60:
            self = .physicalCritical
        default:
            return nil
        }
    }
}

extension Skill.Action {
    
    private var arguments: [Double] {
        return [actionValue1, actionValue2, actionValue3, actionValue4, actionValue5, actionValue6, actionValue7]
    }
    
    var type: ActionType {
        return ActionType(rawValue: actionType) ?? .unknown
    }
    
    var `class`: ActionClass {
        return ActionClass(rawValue: actionDetail1) ?? .unknown
    }
    
    var ailment: Ailment {
        return Ailment(type: actionType, detail: actionDetail1)
    }
    
    var auraModifier: AuraModifier {
        return AuraModifier(actionDetail1)
    }
    
    var propertyKey: PropertyKey {
        return PropertyKey(actionDetail1) ?? .unknown
    }
    
    var percentModifier: PercentModifier {
        return PercentModifier(Int(actionValue1))
    }
    
    var values: [ActionValue] {
        switch (type, `class`, ailment.ailmentType) {
        case (.damage, .magical, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case (.damage, .physical, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        case (.heal, .magical, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .magicStr, value: String(actionValue4))
            ]
        case (.heal, .physical, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .atk, value: String(actionValue4))
            ]
        case (.knock, _, _):
            return [
                ActionValue(key: .distance, value: String(actionValue1)),
                ActionValue(key: .speed, value: String(actionValue3))
            ]
        case (.guard, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        case (.healingPool, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3)),
                ActionValue(key: .duration, value: String(actionValue5))
            ]
        case (.defDownPoll, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        case (.ex, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
            ]
        case (_, _, .action):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        case (_, _, let ailment) where [.darken, .charm, .silence].contains(ailment):
            return [
                ActionValue(key: .chance, value: String(actionValue3)),
                ActionValue(key: .duration, value: String(actionValue1))
            ]
        case (_, _, .dot):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        case (.aura, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .duration, value: String(actionValue4))
            ]
        case (.tp, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
            ]
        case (.additionalDamage, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .stack, value: String(actionValue4))
            ]
        case (.invulnerable, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
            ]
        case (.taunt, _, _):
            return [
                ActionValue(key: .duration, value: String(actionValue1))
            ]
        default:
            return []
        }
    }
    
    func localizedDetail(of level: Int = CDSettingsViewController.Setting.default.skillLevel) -> String {
        switch (type, ailment.ailmentType) {
        case (.heal, _):
            let format = NSLocalizedString("Restore [%@]%@ HP.", comment: "")
            return String(format: format, actionValue(of: level), percentModifier.description)
        case (.guard, _):
            switch `class` {
            case .unknown:
                let format = NSLocalizedString("Unknown field %d for %@s.", comment: "")
                return String(format: format, actionDetail1, durationValue())
            case .physical, .magical:
                let format = NSLocalizedString("Nullify [%@] %@ for %@s.", comment: "")
                return String(format: format, actionValue(of: level), `class`.description, durationValue())
            case .physicalAbsorb:
                let format = NSLocalizedString("Absorb [%@] physical damage for %@s.", comment: "")
                return String(format: format, actionValue(of: level), durationValue())
            case .magicalAbsorb:
                let format = NSLocalizedString("Absorb [%@] magical damage for %@s.", comment: "")
                return String(format: format, actionValue(of: level), durationValue())
            case .physicalMagicAbsorb:
                let format = NSLocalizedString("Absorb [%@] physical and magical damage for %@s.", comment: "")
                return String(format: format, actionValue(of: level), durationValue())
            }
        case (.damage, _):
            let format = NSLocalizedString("Deal [%@] %@.", comment: "Deal [x] physical damage/magical damage.")
            return String(format: format, actionValue(of: level), `class`.description)
        case (.ex, _):
            let format = NSLocalizedString("Raise [%@] %@.", comment: "Raise [x] ATK.")
            return String(format: format, actionValue(of: level), propertyKey.description)
        case (_, .action):
            switch ailment.ailmentDetail {
            case .some(.action(.haste)):
                let format = NSLocalizedString("Haste [%@] for %@s.", comment: "Haste [1.5] for 10s.")
                return String(format: format, actionValue(of: level), durationValue())
            case .some(.action(.slow)):
                let format = NSLocalizedString("Slow [%@] for %@s.", comment: "Slow [0.5] for 10s.")
                return String(format: format, actionValue(of: level), durationValue())
            case .some(.action(.sleep)):
                let format = NSLocalizedString("Make target fall asleep for %@s.", comment: "")
                return String(format: format, durationValue())
            default:
                let format = NSLocalizedString("%@ target for %@s.", comment: "Stun target for 5s.")
                return String(format: format, ailment.description, durationValue())
            }
        case (_, .dot):
            switch ailment.ailmentDetail {
            case .some(.dot(.poison)):
                let format = NSLocalizedString("Poison target and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, actionValue(of: level), durationValue())
            default:
                let format = NSLocalizedString("%@ target and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, ailment.description, actionValue(of: level), durationValue())
            }
        case (_, let type) where [.darken, .charm, .silence].contains(type):
            let format = NSLocalizedString("%@ target with [%@]%% chance for %@s.", comment: "Charm target with [90]% chance for 10s.")
            return String(format: format, ailment.description, actionValue(of: level), durationValue())
        case (.aura, _):
            let format = NSLocalizedString("%@ [%@]%@ %@ for %@s.", comment: "Raise [x]% ATK for 10s.")
            return String(format: format, auraModifier.description, actionValue(of: level), percentModifier.description, propertyKey.description, durationValue())
        case (.position, _):
            let format = NSLocalizedString("Change self position.", comment: "")
            return String(format: format)
        case (.tp, _):
            switch auraModifier {
            case .steal:
                let format = NSLocalizedString("Make target lose [%@] TP.", comment: "")
                return String(format: format, actionValue(of: level))
            default:
                let format = NSLocalizedString("%@ [%@] TP.", comment: "Restore [x] TP.")
                return String(format: format, auraModifier.description, actionValue(of: level))
            }
        case (.additionalDamage, _):
            let format = NSLocalizedString("Add additional damage [%@] with max %@ stacks.", comment: "")
            return String(format: format, actionValue(of: level), stackValue())
        case (.invulnerable, _):
            let format = NSLocalizedString("Become invulnerable for [%@]s.", comment: "")
            return String(format: format, actionValue(of: level))
        case (.taunt, _):
            let format = NSLocalizedString("Taunt targets for %@s.", comment: "")
            return String(format: format, durationValue())
        case (.summon, _):
            let format = NSLocalizedString("Summon minion ID %d.", comment: "")
            return String(format: format, actionDetail2)
        case (.healingPool, _):
            let format = NSLocalizedString("Summon a healing pool to heal [%@] for %@s.", comment: "")
            return String(format: format, actionValue(of: level), durationValue())
        case (.defDownPoll, _):
            let format = NSLocalizedString("Summon a pool to reduce [%@] DEF for %@s.", comment: "")
            return String(format: format, actionValue(of: level), durationValue())
        case (.instantDeath, _):
            return NSLocalizedString("Die instantly.", comment: "")
        case (.chooseArea, _):
            return NSLocalizedString("Choose target area.", comment: "")
        case (.knock, _):
            let format = NSLocalizedString("Knock target away %d at speed %d.", comment: "Knock target away 1000 at speed 500.")
            return String(format: format, Int(actionValue1.rounded()), Int(actionValue3.rounded()))
        default:
            let format = NSLocalizedString("Unknown effect %d with arguments %@.", comment: "")
            return String(format: format, actionType, arguments.filter { $0 != 0 }.map(String.init).joined(separator: ", "))
        }
        
    }
    
    private func actionValue(of level: Int) -> String {
        var expression = ""
        var fixedValue = 0.0
        for value in values {
            if let value = Double(value.value), value == 0 { continue }
            switch value.key {
            case .atk:
                expression += "\(value.value) * \(PropertyKey.atk)"
            case .magicStr:
                expression += "\(value.value) * \(PropertyKey.magicStr)"
            case .def:
                expression += "\(value.value) * \(PropertyKey.def)"
            case .skillLevel:
                fixedValue += Double(level) * (Double(value.value) ?? 0)
            case .initialValue:
                fixedValue += Double(value.value) ?? 0
            case .chance:
                fixedValue = Double(value.value) ?? 0
            default:
                break
            }
        }
        
        var valueString = ""
        switch (type, ailment.ailmentType) {
        case (.invulnerable, _), (_, .action):
            valueString = String(fixedValue)
        default:
            valueString = String(Int(floor(fixedValue)))
        }
        
        if expression != "" {
            return "\(expression) + \(valueString)@\(level)"
        } else {
            return "\(valueString)@\(level)"
        }
    }
    
    private func durationValue() -> String {
        var fixedValue = 0.0
        for value in values {
            switch value.key {
            case .duration:
                fixedValue = Double(value.value) ?? 0
            default:
                break
            }
        }
        
        let valueString = String(fixedValue)
        
        return "\(valueString)"
    }
    
    private func stackValue() -> String {
        var fixedValue = 0.0
        for value in values {
            switch value.key {
            case .stack:
                fixedValue = Double(value.value) ?? 0
            default:
                break
            }
        }
        
        let valueString = String(Int(floor(fixedValue)))
        
        return "\(valueString)"
    }
}
