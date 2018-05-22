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
    case tp
    case hpCondition
    case hold
    
    case taunt = 20
    case invulnerable
    
    case ifStatement = 27
    case switchStatement = 28
    case instantDeath = 30
    
    case additionalLifeSteal = 32
    case additionalDamage = 34
    case healingPool = 37
    case defDownPool = 38
    
    case jumpForward = 42
    
    case gravity = 46
    
    case hot = 48
    
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

enum TargetAssignment: Int, CustomStringConvertible {
    case enemy = 1
    case friend
    case none
    
    var description: String {
        switch self {
        case .enemy:
            return NSLocalizedString("enemy", comment: "target modifier")
        case .friend:
            return NSLocalizedString("friendly", comment: "target modifier")
        case .none:
            return "none"
        }
    }
    
}

enum RangeModifier {
    
    case zero
    case all
    case finite(Int)
    case infinite
    
    case unknown(Int)
    
    init(range: Int) {
        switch range {
        case -1:
            self = .infinite
        case 0:
            self = .zero
        case 1..<2160:
            self = .finite(range)
        case 2160...:
            self = .all
        default:
            self = .unknown(range)
        }
    }
    
}

enum TargetPluralModifier: String, CustomStringConvertible {
    case target
    case targets
    var description: String {
        switch self {
        case .target:
            return NSLocalizedString("target", comment: "")
        case .targets:
            return NSLocalizedString("targets", comment: "")
        }
    }
}

enum TargetCountModifier: Int, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .zero:
            return NSLocalizedString("last effect affected", comment: "")
        case .one:
            return NSLocalizedString("one", comment: "")
        case .two:
            return NSLocalizedString("two", comment: "")
        case .three:
            return NSLocalizedString("three", comment: "")
        case .four:
            return NSLocalizedString("four", comment: "")
        default:
            return NSLocalizedString("all", comment: "")
        }
    }
    
    var pluralModifier: TargetPluralModifier {
        switch self {
        case .one:
            return .target
        default:
            return .targets
        }
    }
    case zero = 0
    case one = 1
    case two
    case three
    case four
    case all = 99
}

enum TargetTypeModifier: Int, CustomStringConvertible {
    case none = -1
    // not sure for 1, 2 ,3
//    case forward = 2
//    case centre = 3
    case fromBack = 4
    case lowestHP = 5
    case highestHP = 6
    case `self` = 7
    case highestTP = 12
    case lowestTP = 13
    case highestATK = 14
    case highestMagicSTR = 16
    var description: String {
        switch self {
        case .`self`:
            return NSLocalizedString("self", comment: "")
        case .highestATK:
            return NSLocalizedString("the highest ATK", comment: "")
        case .lowestHP:
            return NSLocalizedString("the lowest current HP", comment: "")
        case .highestHP:
            return NSLocalizedString("the highest current HP", comment: "")
        case .lowestTP:
            return NSLocalizedString("the lowest TP", comment: "")
        case .highestTP:
            return NSLocalizedString("the highest TP", comment: "")
        case .highestMagicSTR:
            return NSLocalizedString("the highest Magic STR", comment: "")
        case .fromBack:
            return NSLocalizedString("the farthest", comment: "")
        default:
            return ""
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
    
    var assignment: TargetAssignment {
        return TargetAssignment(rawValue: targetAssignment) ?? .none
    }
    
    var countModifier: TargetCountModifier {
        return TargetCountModifier(rawValue: targetCount) ?? .all
    }
    
    var pluralModifier: TargetPluralModifier {
        return countModifier.pluralModifier
    }
    
    var rangeModifier: RangeModifier {
        return RangeModifier(range: targetRange)
    }
    
    var targetTypeModifier: TargetTypeModifier {
        return TargetTypeModifier(rawValue: targetType) ?? .none
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
        case (.defDownPool, _, _):
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
        case (.additionalLifeSteal, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue2)),
                ActionValue(key: .skillLevel, value: String(actionValue3)),
                ActionValue(key: .duration, value: String(actionValue1))
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
        case (.hot, .magical, _):
            return [
                ActionValue(key: .duration, value: String(actionValue5)),
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .magicStr, value: String(actionValue3))
            ]
        case (.hot, .physical, _):
            return [
                ActionValue(key: .duration, value: String(actionValue5)),
                ActionValue(key: .initialValue, value: String(actionValue1)),
                ActionValue(key: .skillLevel, value: String(actionValue2)),
                ActionValue(key: .atk, value: String(actionValue3))
            ]
        case (.jumpForward, _, _):
            return [
                ActionValue(key: .duration, value: String(actionValue4))
            ]
        case (.hold, _, _):
            return [
                ActionValue(key: .duration, value: String(actionValue3))
            ]
        case (.gravity, _, _):
            return [
                ActionValue(key: .initialValue, value: String(actionValue1))
            ]
            
        default:
            return []
        }
    }
    
    func localizedDetail(of level: Int = CDSettingsViewController.Setting.default.skillLevel) -> String {
        switch (type, ailment.ailmentType) {
        case (.heal, _):
            let format = NSLocalizedString("Restore [%@]%@ HP to %@.", comment: "")
            return String(format: format, actionValue(of: level), percentModifier.description, targetValue())
        case (.guard, _):
            switch `class` {
            case .unknown:
                let format = NSLocalizedString("Cast an unknown barrier %d on %@ for %@s.", comment: "")
                return String(format: format, actionDetail1, targetValue(), durationValue())
            case .physical, .magical:
                let format = NSLocalizedString("Cast a barrier on %@ to nullify [%@] %@ for %@s.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level), `class`.description, durationValue())
            case .physicalAbsorb:
                let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] physical damage for %@s.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level), durationValue())
            case .magicalAbsorb:
                let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] magical damage for %@s.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level), durationValue())
            case .physicalMagicAbsorb:
                let format = NSLocalizedString("Cast a barrier on %@ to absorb [%@] physical and magical damage for %@s.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level), durationValue())
            }
        case (.damage, _):
            let format = NSLocalizedString("Deal [%@] %@ to %@.", comment: "Deal [x] physical damage/magical damage to one enemy target.")
            return String(format: format, actionValue(of: level), `class`.description, targetValue())
        case (.ex, _):
            let format = NSLocalizedString("Raise [%@] %@.", comment: "Raise [x] ATK.")
            return String(format: format, actionValue(of: level), propertyKey.description)
        case (_, .action):
            switch ailment.ailmentDetail {
            case .some(.action(.haste)):
                let format = NSLocalizedString("Raise %@ %d%% attack speed for %@s.", comment: "Raise all friendly targets 50% attack speed for 10s.")
                return String(format: format, targetValue(), Int(((actionValue1 - 1) * 100).rounded()), durationValue())
            case .some(.action(.slow)):
                let format = NSLocalizedString("Reduce %@ %d%% attack speed for %@s.", comment: "Reduce one enemy target 50% attack speed for 10s.")
                return String(format: format, targetValue(), Int(((1 - actionValue1) * 100).rounded()), durationValue())
            case .some(.action(.sleep)):
                let format = NSLocalizedString("Make %@ fall asleep for %@s.", comment: "")
                return String(format: format, targetValue(), durationValue())
            default:
                let format = NSLocalizedString("%@ %@ for %@s.", comment: "Stun one enemy target for 5s.")
                return String(format: format, ailment.description, targetValue(), durationValue())
            }
        case (_, .dot):
            switch ailment.ailmentDetail {
            case .some(.dot(.poison)):
                let format = NSLocalizedString("Poison %@ and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level), durationValue())
            default:
                let format = NSLocalizedString("%@ %@ and deal [%@] damage per second for %@s.", comment: "")
                return String(format: format, ailment.description, targetValue(), actionValue(of: level), durationValue())
            }
        case (_, .charm), (_, .silence):
            let format = NSLocalizedString("%@ %@ with [%@]%% chance for %@s.", comment: "Charm all enemy targets with [90]% chance for 10s.")
            return String(format: format, ailment.description, targetValue(), actionValue(of: level), durationValue())
        case (_, .darken):
            let format = NSLocalizedString("Darken %@ with [%@]%% chance for %@s.", comment: "")
            return String(format: format, targetValue(), actionValue(of: level), durationValue())
        case (.aura, _):
            let format = NSLocalizedString("%@ %@ [%@]%@ %@ for %@s.", comment: "Raise one friendly target [x]% ATK for 10s.")
            return String(format: format, auraModifier.description, targetValue(), actionValue(of: level), percentModifier.description, propertyKey.description, durationValue())
        case (.position, _):
            let format = NSLocalizedString("Change self position.", comment: "")
            return String(format: format)
        case (.tp, _):
            switch auraModifier {
            case .steal:
                let format = NSLocalizedString("Make %@ lose [%@] TP.", comment: "")
                return String(format: format, targetValue(), actionValue(of: level))
            default:
                let format = NSLocalizedString("%@ %@ [%@] TP.", comment: "Restore one friendly target [x] TP.")
                return String(format: format, auraModifier.description, targetValue(), actionValue(of: level))
            }
        case (.additionalDamage, _):
            let format = NSLocalizedString("Add additional damage [%@] with max %@ stacks.", comment: "")
            return String(format: format, actionValue(of: level), stackValue())
        case (.invulnerable, _):
            let format = NSLocalizedString("Become invulnerable for [%@]s.", comment: "")
            return String(format: format, actionValue(of: level))
        case (.taunt, _):
            let format = NSLocalizedString("Taunt all enemy targets for %@s.", comment: "")
            return String(format: format, durationValue())
        case (.summon, _):
            let format = NSLocalizedString("Summon minion ID %d.", comment: "")
            return String(format: format, actionDetail2)
        case (.healingPool, _):
            let format = NSLocalizedString("Summon a healing pool to heal all friendly targets in range %d [%@] HP per second for %@s.", comment: "")
            return String(format: format, Int(actionValue7.rounded()), actionValue(of: level), durationValue())
        case (.defDownPool, _):
            let format = NSLocalizedString("Summon a pool to reduce %@ [%@] DEF for %@s.", comment: "")
            return String(format: format, targetValue(), actionValue(of: level), durationValue())
        case (.instantDeath, _):
            return NSLocalizedString("Die instantly.", comment: "")
        case (.chooseArea, _):
            return NSLocalizedString("Choose target area.", comment: "")
        case (.knock, _):
            let format = NSLocalizedString("Knock %@ away %d at speed %d.", comment: "Knock target away 1000 at speed 500.")
            return String(format: format, targetValue(), Int(actionValue1.rounded()), Int(actionValue3.rounded()))
        case (.hot, _):
            let format = NSLocalizedString("Restore %@ [%@] HP per second for %@s.", comment: "")
            return String(format: format, targetValue(), actionValue(of: level), durationValue())
        case (.switchStatement, _), (.ifStatement, _):
            let format = NSLocalizedString("Internal statement.", comment: "")
            return String(format: format)
        case (.jumpForward, _):
            let format = NSLocalizedString("Jump forward %d and hold there for %@s.", comment: "")
            return String(format: format, Int(actionValue1.rounded()), durationValue())
        case (.hold, _):
            let format = NSLocalizedString("Hold for %@s.", comment: "")
            return String(format: format, durationValue())
        case (.hpCondition, _):
            let format = NSLocalizedString("Condition: HP is below %d%%.", comment: "")
            return String(format: format, Int(actionValue3.rounded()))
        case (.gravity, _):
            let format = NSLocalizedString("Deal damage equal to [%@]%% of target's max HP to %@.", comment: "")
            return String(format: format, actionValue(of: level), targetValue())
        case (.additionalLifeSteal, _):
            let format = NSLocalizedString("Add additional [%@] %@ to %@ for next attack within %@s.", comment: "")
            return String(format: format, actionValue(of: level), PropertyKey.lifeSteal.description, targetValue(), durationValue())
        default:
            let format = NSLocalizedString("Unknown effect %d with arguments [%@] on %@.", comment: "")
            return String(format: format, actionType, arguments.filter { $0 != 0 }.map(String.init).joined(separator: ", "), targetValue())
        }
        
    }
    
    private func actionValue(of level: Int) -> String {
        var expression = ""
        var fixedValue = 0.0
        var hasLevelCoefficient = false
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
                hasLevelCoefficient = true
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
            expression = "\(expression) + \(valueString)"
        } else {
            expression = "\(valueString)"
        }
        
        if hasLevelCoefficient {
            expression += "@\(level)"
        }
        return expression
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
    
    private func targetValue() -> String {
        switch (targetTypeModifier, rangeModifier, countModifier) {
        case (_, _, .zero):
            let format = NSLocalizedString("%@ %@", comment: "one target/two targets")
            return String(format: format, countModifier.description, pluralModifier.description)
        case (.`self`, _, _):
            return targetTypeModifier.description
        case (.highestATK, _, _),
             (.lowestHP, _, _),
             (.lowestTP, _, _),
             (.highestTP, _, _),
             (.highestMagicSTR, _, _),
             (.highestHP, _, _):
            let format: String
            if case .finite(let range) = rangeModifier {
                format = NSLocalizedString("%@ %@ target in range %d", comment: "")
                return String(format: format, targetTypeModifier.description, assignment.description, range)
            } else {
                format = NSLocalizedString("%@ %@ %@", comment: "")
                return String(format: format, targetTypeModifier.description, assignment.description, pluralModifier.description)
            }
//        case (.fromBack, .finite(let range), .all):
//            let format = NSLocalizedString("all %@ %@ %@ in range %d", comment: "")
//            return String(format: format, assignment.description, targetTypeModifier.description, pluralModifier.description, range)
        case (.fromBack, .finite(let range), _):
            let format = NSLocalizedString("up to %@ %@ %@ %@ in range %d", comment: "")
            return String(format: format, countModifier.description, targetTypeModifier.description, assignment.description, pluralModifier.description, range)
        case (.fromBack, _, _):
            let format = NSLocalizedString("%@ %@ %@ %@", comment: "")
            return String(format: format, targetTypeModifier.description, countModifier.description, assignment.description, pluralModifier.description)
        case (_, .zero, _):
            if targetType == 3 && assignment == .friend && targetCount == 1 {
                return TargetTypeModifier.`self`.description
            } else {
                let format = NSLocalizedString("%@ %@ %@", tableName: "Localizable2", comment: "three enemy targets")
                return String(format: format, countModifier.description, assignment.description, pluralModifier.description)
            }
        case (_, .finite(let range), .all):
            let format = NSLocalizedString("all %@ %@ in range %d", comment: "")
            return String(format: format, assignment.description, pluralModifier.description, range)
        case (_, .finite(let range), _):
            let format = NSLocalizedString("up to %@ %@ %@ in range %d", comment: "")
            return String(format: format, countModifier.description, assignment.description, pluralModifier.description, range)
        default:
            let format = NSLocalizedString("%@ %@ %@", tableName: "Localizable2", comment: "three enemy targets")
            return String(format: format, countModifier.description, assignment.description, pluralModifier.description)
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
}
