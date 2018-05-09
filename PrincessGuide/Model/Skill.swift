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

enum ActionKey: String, CustomStringConvertible {
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
        case .chance:
            return NSLocalizedString("Chance", comment: "")
        case .stack:
            return NSLocalizedString("Stack", comment: "")
        case .def:
            return NSLocalizedString("DEF", comment: "")
        case .distance:
            return NSLocalizedString("Distance", comment: "")
        case .speed:
            return NSLocalizedString("Speed", comment: "")
        }
    }
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
    case cursingPool = 38
    
    case ex = 90
}

enum ActionClass: Int, CustomStringConvertible {
    case unknown = 0
    case physical
    case magical
    case physicalAbsorb
    case magicAbsorb
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
        case .magicAbsorb:
            return NSLocalizedString("magical absorb field", comment: "")
        case .physicalMagicAbsorb:
            return NSLocalizedString("physical and magical absorb field", comment: "")
        }
    }
    
}

enum UnitModifier: CustomStringConvertible {
    case percent
    case number
    
    var description: String {
        switch self {
        case .percent:
            return "%%"
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

enum ActionModifier: CustomStringConvertible {
    
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
    
    var modifer: ActionModifier {
        return ActionModifier(actionDetail1)
    }
    
    var unitModifier: UnitModifier {
        return UnitModifier(Int(actionValue1))
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
        case (.cursingPool, _, _):
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
    
    private func buildActionDescription() -> String {
        switch (type, ailment.ailmentType) {
        case (.heal, _):
            return NSLocalizedString("Restore [%@]\(unitModifier) HP", comment: "")
        case (.guard, _):
            switch `class` {
            case .unknown:
                return NSLocalizedString("Unknown field", comment: "")
            case .physical, .magical:
                return NSLocalizedString("Nullify [%@] \(`class`)", comment: "")
            case .physicalAbsorb:
                return NSLocalizedString("Absorb [%@] physical damage", comment: "")
            case .magicAbsorb:
                return NSLocalizedString("Absorb [%@] magical damage", comment: "")
            case .physicalMagicAbsorb:
                return NSLocalizedString("Absorb [%@] physical and magical damage", comment: "")
            }
        case (.damage, _):
            return NSLocalizedString("Deal [%@] \(`class`)", comment: "")
        case (.ex, _):
            return NSLocalizedString("Raise [%@] \(PropertyKey(actionDetail1)?.description ?? NSLocalizedString("Unknown", comment: ""))", comment: "")
        case (_, .action):
            switch ailment.ailmentDetail {
            case .some(.action(.haste)), .some(.action(.slow)):
                return "\(ailment) [%@]"
            default:
                return "\(ailment) target"
            }
        case (_, .dot):
            return "\(ailment) target and deal [%@] damage per second"
        case (_, let type) where [.darken, .charm, .silence].contains(type):
            return "\(ailment) target with [%@]%% chance"
        case (.aura, _):
            return NSLocalizedString("\(modifer) [%@]\(unitModifier) \(PropertyKey(actionDetail1)?.description ?? NSLocalizedString("Unknown", comment: ""))", comment: "")
        case (.position, _):
            return NSLocalizedString("Change self position", comment: "")
        case (.tp, _):
            return NSLocalizedString("\(modifer) [%@] TP", comment: "")
        case (.additionalDamage, _):
            return NSLocalizedString("Add additional damage [%@]", comment: "")
        case (.invulnerable, _):
            return NSLocalizedString("Become invulnerable for [%@]s", comment: "")
        case (.taunt, _):
            return NSLocalizedString("Taunt target", comment: "")
        case (.summon, _):
            let format = NSLocalizedString("Summon minion ID %d", comment: "")
            return String(format: format, actionDetail2)
        case (.healingPool, _):
            return NSLocalizedString("Summon a healing pool to heal [%@]", comment: "")
        case (.cursingPool, _):
            return NSLocalizedString("Summon a pool to reduce [%@] DEF", comment: "")
        case (.instantDeath, _):
            return NSLocalizedString("Die instantly", comment: "")
        case (.chooseArea, _):
            return NSLocalizedString("Choose target area", comment: "")
        case (.knock, _):
            let format = NSLocalizedString("Knock target away %d distance in %d speed", comment: "")
            return String(format: format, Int(actionValue1.rounded()), Int(actionValue3.rounded()))
        default:
            let format = NSLocalizedString("Unknown effect %d with arguments %@", comment: "")
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
    
    private func buildDurationDescription() -> String {
        switch (type, ailment.ailmentType) {
        case (_, .dot):
            return NSLocalizedString(" over %@s", comment: "")
        case (_, let ailment) where ![.unknown, .instantDeath, .dot].contains(ailment):
            return NSLocalizedString(" for %@s", comment: "")
        case (.aura, _), (.taunt, _), (.healingPool, _), (.guard, _):
            return NSLocalizedString(" for %@s", comment: "")
        default:
            return ""
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
    
    private func buildStackDescription() -> String {
        switch type {
        case .additionalDamage:
            return NSLocalizedString(" with max %@ stacks", comment: "")
        default:
            return ""
        }
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
    
    func detail(of level: Int = CDSettingsViewController.Setting.default.skillLevel) -> String {
        return String(format: buildActionDescription(), actionValue(of: level)) + String(format: buildStackDescription(), stackValue()) + String(format: buildDurationDescription(), durationValue()) + NSLocalizedString(".", comment: "")
    }
}
